//
//  HttpResult.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 28/05/22.
//

import Foundation

struct HttpResult {
    private (set) var identifier: RequestIdentifier
    private (set) var transactionId: String
    private (set) var result: Result<AnyResponse, Error>
}
