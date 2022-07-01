//
//  AnyRequest.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 28/05/22.
//

import Foundation


public struct AnyRequest: Request {
    public var identifier: RequestIdentifier
    public var urlRequest: URLRequest
    public var attempt: Int = 0
    public var transactionId: String = UUID().uuidString
    public var maxRetryCount: Int
    
    public init(identifier: RequestIdentifier, urlRequest: URLRequest,
                maxRetryCount: Int = 0) {
        self.identifier = identifier
        self.urlRequest = urlRequest
        self.maxRetryCount = maxRetryCount
    }
}
