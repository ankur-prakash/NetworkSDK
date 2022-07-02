//
//  RequestBuilder.swift
//  Utils
//
//  Created by Ankur Prakash on 29/04/22.
//

import Foundation

public struct RequestBuilder {
    
    public enum HttpHeader: String, Hashable {
        case Authorization
        case contentType = "content-type"
    }
    
    public struct URLRequestConfiguration {
        var timeout: TimeInterval = 60.0
        var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    }
    
    public enum HttpMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    public static func request(with url: URL, method: HttpMethod,
                               headers: [HttpHeader: String], httpBody: Data? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key.rawValue)
        }
        return request
    }
}
