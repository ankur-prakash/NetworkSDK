//
//  HTTPError.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 30/05/22.
//

import Foundation

enum HTTPErrors: Int {
    case unAuthorized = 401
    case badRequest = 400
    case serverInternalError = 500
}
