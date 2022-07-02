//
//  HTTPRequestOperationQueue.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 29/05/22.
//

import Foundation
import Combine
import OrderedCollections

private let AuthorizationHeader = "Authorization"

public class HTTPRequestOperationQueue: NSObject {
    
    private let operationQueue = OperationQueue()
    private let httpResultSubject = PassthroughSubject<HttpResult, Never>()
    private let unAuthorizedErrorSubject = PassthroughSubject<Void, Never>()
    private let fatalErrorSubject = PassthroughSubject<Void, Never>()
    private var requestQueue = OrderedDictionary<String, Request>()
    private let httpRequestQueue = DispatchQueue(label: "com.ankurprakash.http_private_queue")
    private var store = Set<AnyCancellable>()
    public lazy var requestDidUnAuthorized = self.unAuthorizedErrorSubject.eraseToAnyPublisher()
    public lazy var fatalErrorOccurred = self.fatalErrorSubject.eraseToAnyPublisher()

    public init(maximumConcurrentAllowed: Int) {
        super.init()
        operationQueue.maxConcurrentOperationCount = maximumConcurrentAllowed
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    private var session: URLSession!
    
    public func enqueueRequest(_ request: Request) -> AnyPublisher<AnyResponse, Error> {
        defer {
            httpRequestQueue.async { [weak self] in
                guard let self = self else { return }
                self.requestQueue[request.transactionId] = request
                self.operationQueue.addOperation(DownloadOperation(session: self.session,
                                                                    request: request,
                                                                    delegate: self))
            }
        }
        return httpResultSubject
            .filter { $0.transactionId == request.transactionId }
            .first()
            .handleHttpResult()
            .eraseToAnyPublisher()
    }
    
    func cancelAll() {
        httpRequestQueue.async { [weak self] in
            self?.operationQueue.cancelAllOperations()
        }
    }
    
    public func rescheduleWithNewToken(_ accessToken: String) {
        httpRequestQueue.async { [weak self] in
            guard let self = self else { return }
            self.requestQueue.forEach {
                // update access Token for requests
                var anyRequest = $0.value
                anyRequest.urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: AuthorizationHeader)
                self.operationQueue.addOperation(DownloadOperation(session: self.session,
                                                                   request: anyRequest,
                                                                   delegate: self))
            }
        }
    }
    
    func suspend() {
        httpRequestQueue.async { [weak self] in
            self?.operationQueue.isSuspended = true
        }
    }
    
    func resume() {
        httpRequestQueue.async { [weak self] in
            self?.operationQueue.isSuspended = false
        }
    }
}

extension HTTPRequestOperationQueue: DownloadOperationDelegate {
    
    func beginDownload(_ result: Request) {
        RequestLogger.log(result)
    }
    
    func response(_ result: HttpResult, for request: Request) {
        httpRequestQueue.async { [weak self] in
            
            guard let self = self else { return }
            switch result.result {
            case .success(let response):
                RequestLogger.log(response)
                //TODO: Handle Refresh token 400
                if response.request.identifier == .refreshtoken && response.status == HTTPErrors.badRequest.rawValue {
                    self.cancelAll()
                    self.fatalErrorSubject.send(())
                }
                else if response.status == HTTPErrors.unAuthorized.rawValue {
                    self.cancelAll()
                    self.unAuthorizedErrorSubject.send(())
                } else {
                    self.requestQueue.removeValue(forKey: response.request.transactionId)
                }
                //for sucess always sends result back
                self.httpResultSubject.send(result)
            case .failure(let error):
                RequestLogger.log(request, withError: error)
                //for failure send when attempt exceeds
                var newRequest = request
                newRequest.attempt += 1
                guard newRequest.attempt < request.maxRetryCount else {
                    self.requestQueue.removeValue(forKey: request.transactionId)
                    self.httpResultSubject.send(result)
                    return
                }
                self.requestQueue[newRequest.transactionId] = newRequest
                self.operationQueue.addOperation(DownloadOperation(session: self.session,
                                                                   request: newRequest,
                                                                   delegate: self))
            }
        }
    }
}

private extension Publisher where Output == HttpResult {
    
    func handleHttpResult() -> AnyPublisher<AnyResponse, Error> {
    
        tryCompactMap { result -> AnyResponse? in
            switch result.result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }.eraseToAnyPublisher()
    }
}

extension HTTPRequestOperationQueue: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if challenge.protectionSpace.serverTrust == nil {
                completionHandler(.useCredential, nil)
            } else {
                let trust: SecTrust = challenge.protectionSpace.serverTrust!
                let credential = URLCredential(trust: trust)
                completionHandler(.useCredential, credential)
            }
        }

}

/*
 
 extension HTTPRequestOperationQueue: URLSessionDelegate {
     
     public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
         
         if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
             if let serverTrust = challenge.protectionSpace.serverTrust {
                 var secresult: CFError?
                 let status = SecTrustEvaluateWithError(serverTrust, &secresult)
                 
                 guard status else {
                     // Pinning failed
                     RequestLogger.log("Authentication Failed \(String(describing: secresult))")
                     completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                     return
                 }
                 RequestLogger.log("Authentication Success")
                 if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                     let serverCertificateData = SecCertificateCopyData(serverCertificate)
                     let data = CFDataGetBytePtr(serverCertificateData);
                     let size = CFDataGetLength(serverCertificateData);
                     let cert1 = NSData(bytes: data, length: size)
                     let file_der = Bundle.main.path(forResource: "clientkey", ofType: "pem")
                     
                     if let file = file_der {
                         if let cert2 = NSData(contentsOfFile: file) {
                             if cert1.isEqual(to: cert2 as Data) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                 return
                             }
                         }
                     }
                 }
             }
         } else {
             RequestLogger.log("Authentication Failed")
             completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
         }
     }
 }

 */
