//
//  FailureResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 05/06/22.
//

import Foundation

protocol FailureResponse {
    var status: String? { get }
    var error: String { get }
}

struct ServerErrorResponse: Decodable {
    
    var status: String?
    var error: String
}

extension ServerErrorResponse: FailureResponse {}
