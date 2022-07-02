//
//  URLBuilder.swift
//  Utils
//
//  Created by Ankur Prakash on 27/04/22.
//

import Foundation

public struct URLBuilder {
    
    private init() {}
    public enum HTTPMethod: String {
        case POST
        case GET
    }
    
    public enum TransferProtocol: String {
        case http
        case https
    }
    
    public enum Host {
        case host(_ host: String)
    }
    
    public enum Path {
        case path(_ value: String)
    }
    
    public static func build(parameters: [String: String],
                             protocolType: TransferProtocol,
                             host: Host,
                             path: Path,
                             port: Int? = nil) -> URL? {
        var components = URLComponents()
        
        var items = [URLQueryItem]()
        parameters.forEach { args in
            items.append(URLQueryItem(name: args.key, value: args.value))
        }
        if !items.isEmpty {
            components.queryItems = items
        }
        components.scheme = protocolType.rawValue
        if case .host(let domain) = host {
            components.host = domain
        }
        if case .path(let path) = path {
            components.path = path
        }
        if let port = port {
            components.port = port
        }
        return components.url
    }
}
