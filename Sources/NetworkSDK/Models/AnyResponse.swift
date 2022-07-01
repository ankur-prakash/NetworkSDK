//
//  AnyResponse.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 28/05/22.
//

import Foundation

public struct AnyResponse {
   
    public var status: Int = 0
    public let request: Request
    public let data: Data
    public let urlResponse: URLResponse
    
    init(request: Request, data: Data, urlResponse: URLResponse) {
        self.request = request
        self.data = data
        self.urlResponse = urlResponse
        if let httpResponse = urlResponse as? HTTPURLResponse {
            status = httpResponse.statusCode
        }
    }
}

extension AnyResponse: Response {}
