//
//  DataCollectionUploadResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 08/06/22.
//

import Foundation

protocol SuccessResponse {
    var status: String { get }
    var message: String? { get }
}

struct CommonSuccessResponse: Decodable {
    let status: String
    let message: String?
}

extension CommonSuccessResponse: SuccessResponse {}
