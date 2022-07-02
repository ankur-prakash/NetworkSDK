//
//  RequestManager.swift
//  Backend
//
//  Created by Ankur Prakash on 29/04/22.
//

import Foundation
import UIKit
import Combine


final class NetworkRequestConstructor {
    
    enum CustomServerPath: String {
        case imageUpload = "/api/image"
        case useCases = "/api/use-case/list"
        case imageAnnotate = "/api/image/annotate"
        case dataCollection = "/api/image/analyze"
        
        enum Auth: String {
            case auth = "/auth/login"
            case refresh = "/auth/refresh"
            case logout = "/auth/logout"
        }
    }
       
    public init() {}
}

extension NetworkRequestConstructor {
    
    static func request(for apiRequest: NetworkApi,
                        maxRetryCount: Int = 0) throws -> Request {
        
        switch apiRequest.identifier {
            
        case .getUseCases:
            guard let url = URLBuilder.build(parameters: ["type":"video"], path: .path(CustomServerPath.useCases.rawValue)) else {
                throw BackendError.invalidUrl
            }
            let urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .GET, additionalHeaders: [.contentType: ContentType.json.rawValue])
            return AnyRequest(identifier: .getUseCases,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
            
        case .imageUpload:
            guard let url = URLBuilder.build(path: .path(CustomServerPath.imageUpload.rawValue)),
                  let apiRequest = apiRequest as? ImageUploadRequest else {
                throw BackendError.invalidUrl
            }
            let boundary = "Boundary-\(NSUUID().uuidString)"
            let multipartData = MultiPartDataBuilder.createDataBody(data: apiRequest.data, filename: apiRequest.filename, boundary: boundary, withParameters: [RequestAttribute.useCase.rawValue: apiRequest.useCase, RequestAttribute.width.rawValue: "\(apiRequest.width)", RequestAttribute.height.rawValue: "\(apiRequest.height)", RequestAttribute.boundingBox.rawValue: "\(apiRequest.boundingBox)"])
            var urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .POST, additionalHeaders: [.contentType: "\(ContentType.multipartFormData.rawValue); boundary=\(boundary)"], httpBody: multipartData)
            urlRequest.allowsExpensiveNetworkAccess = true
            return AnyRequest(identifier: .imageUpload,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
            
        case .fetchInferenceHistory:
            guard let apiRequest = apiRequest as? InferenceHistoryApi, let url = URLBuilder.build(parameters: [RequestAttribute.page.rawValue: "\(apiRequest.page)", RequestAttribute.boundingBox.rawValue: "\(apiRequest.boundingBox)", RequestAttribute.useCase.rawValue: apiRequest.useCase], path: .path(CustomServerPath.imageUpload.rawValue)) else {
                throw BackendError.invalidUrl
            }
            let urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .GET, additionalHeaders: [.contentType: ContentType.json.rawValue])
            return AnyRequest(identifier: .fetchInferenceHistory,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
            
        case .dataCollectionUpload:
            guard let url = URLBuilder.build(path: .path(CustomServerPath.dataCollection.rawValue)),
                  let apiRequest = apiRequest as? DataCollectionUploadApi else {
                throw BackendError.invalidUrl
            }
            let boundary = "Boundary-\(NSUUID().uuidString)"
            let multipartData = MultiPartDataBuilder.createDataBody(data: apiRequest.data, filename: apiRequest.filename, boundary: boundary, withParameters: [RequestAttribute.useCase.rawValue: apiRequest.useCase])
            var urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .POST, additionalHeaders: [.contentType: "\(ContentType.multipartFormData.rawValue); boundary=\(boundary)"], httpBody: multipartData)
            urlRequest.allowsExpensiveNetworkAccess = true
            return AnyRequest(identifier: .dataCollectionUpload,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
            
        case .dataCollectionHistory:
            guard let apiRequest = apiRequest as? DataCollectionHistoryApi, let url = URLBuilder.build(parameters: [RequestAttribute.page.rawValue: "\(apiRequest.page)", RequestAttribute.useCase.rawValue: apiRequest.useCase], path: .path(CustomServerPath.dataCollection.rawValue)) else {
                throw BackendError.invalidUrl
            }
            let urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .GET, additionalHeaders: [.contentType: ContentType.json.rawValue])
            return AnyRequest(identifier: .dataCollectionHistory,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
            
        case .dataCollectionDelete:
            guard let apiRequest = apiRequest as? DataCollectionDeleteApi, var url = URLBuilder.build(path: .path(CustomServerPath.dataCollection.rawValue)) else {
                throw BackendError.invalidUrl
            }
            url = url.appendingPathComponent(apiRequest.imageId)
            let urlRequest = RequestBuilder.requestWithMandatoryHeaders(with: url, method: .DELETE)
            return AnyRequest(identifier: .dataCollectionDelete,
                              urlRequest: urlRequest,
                              maxRetryCount: maxRetryCount)
        case .login:
            guard let apiRequest = apiRequest as? LoginApi,
                  let loginUrl = CustomServerPath.Auth.auth.url else {
                throw BackendError.invalidUrl
            }
            let request = RequestBuilder.request(with: loginUrl, method: .POST, headers: [RequestBuilder.HttpHeader.contentType: ContentType.json.rawValue], httpBody: [RequestAttribute.email.rawValue: apiRequest.email, RequestAttribute.password.rawValue: apiRequest.password].jsonData)
            return AnyRequest(identifier: .login, urlRequest: request,
                              maxRetryCount: maxRetryCount)
        case .logout:
            guard let apiRequest = apiRequest as? LogoutApi,
                  let logoutUrl = CustomServerPath.Auth.logout.url else {
                throw BackendError.invalidUrl
            }
            
            let request = RequestBuilder.request(with: logoutUrl, method: .POST, headers: [RequestBuilder.HttpHeader.contentType: ContentType.json.rawValue], httpBody: [RequestAttribute.refreshToken.rawValue: apiRequest.accessToken].jsonData)
            
           return AnyRequest(identifier: .logout, urlRequest: request,
                             maxRetryCount: maxRetryCount)
        case .refreshtoken:
            guard let apiRequest = apiRequest as? RefreshTokenApi,
                  let refreshUrl = CustomServerPath.Auth.refresh.url else {
                throw BackendError.invalidUrl
            }
            
            let request = RequestBuilder.request(with: refreshUrl, method: .POST, headers: [RequestBuilder.HttpHeader.contentType: ContentType.json.rawValue], httpBody: [RequestAttribute.refreshToken.rawValue: apiRequest.refreshToken].jsonData)
            
            return AnyRequest(identifier: .refreshtoken, urlRequest: request,
                              maxRetryCount: maxRetryCount)
//        default:
//            print("Request not handled \(apiRequest)")
//            throw BackendError.invalidUrl
        }
    }
}


fileprivate extension RequestBuilder {
    
    static func requestWithMandatoryHeaders(with url: URL, method: HttpMethod,
                                            additionalHeaders: [HttpHeader: String]? = nil, httpBody: Data? = nil) -> URLRequest {
        
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        var mandatoryHeaders: [HttpHeader: String] = [.Authorization: "Bearer \(accessToken)"]
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { mandatoryHeaders[$0.key] = $0.value }
        }
        return RequestBuilder.request(with: url, method: method, headers: mandatoryHeaders, httpBody: httpBody)
    }
}

private extension NetworkRequestConstructor.CustomServerPath.Auth {
    
    var url: URL? {
        URLBuilder.build(parameters: [:], path: .path(self.rawValue))
    }
}

private extension NetworkRequestConstructor {
    
    enum RequestAttribute: String {
        case useCase
        case width
        case height
        case boundingBox
        case refreshToken
        case type
        case video
        case email
        case password
        case page
    }
}

private extension Dictionary {
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
}

private extension Array {
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
}
