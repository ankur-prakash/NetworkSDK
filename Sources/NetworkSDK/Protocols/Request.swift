//
//  Request.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 28/05/22.
//

import Foundation


public protocol Request {
    var identifier: RequestIdentifier { get }
    var urlRequest: URLRequest { get set }
    var attempt: Int { get set }
    var transactionId: String { get }
    var maxRetryCount: Int { get }
}
