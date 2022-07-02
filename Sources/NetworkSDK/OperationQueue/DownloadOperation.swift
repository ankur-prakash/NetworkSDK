//
//  DownloadOperation.swift
//  SwiftUI_Combine
//
//  Created by Ankur Prakash on 29/05/22.
//

import Foundation
import Combine

protocol DownloadOperationDelegate: AnyObject {
    func beginDownload(_ result: Request)
    func response(_ result: HttpResult, for request: Request)
}

class DownloadOperation: Operation {
    
    weak var delegate: DownloadOperationDelegate?
    let request: Request
    var store = Set<AnyCancellable>()
    private var session: URLSession!
    
    init(session: URLSession,
         request: Request, delegate: DownloadOperationDelegate?) {
        self.session = session
        self.request = request
        self.delegate = delegate
    }
    
    public override func main() {
     
        let semaphone = DispatchSemaphore(value: 0)
        delegate?.beginDownload(request)
        session.dataTaskPublisher(for: request.urlRequest)
        .map { [request] in AnyResponse(request: request, data: $0.data, urlResponse: $0.response) }
        .sink { [weak self, request] completion in
            switch completion {
            case .failure(let error):
                self?.handleResponse(.failure(error), for: request)
                semaphone.signal()
            case .finished:
                //self?.isRequestInProgress =  false
                break
            }
        } receiveValue: { [weak self, request] in
            self?.handleResponse(.success($0), for: request)
            semaphone.signal()
        }.store(in: &store)
        semaphone.wait()
    }
    
    func handleResponse(_ result: Result<AnyResponse, Error>,
                        for request: Request) {
        let httpResult = HttpResult(identifier: request.identifier,
                                    transactionId: request.transactionId,
                                    result: result)
        delegate?.response(httpResult, for: request)
    }
}
