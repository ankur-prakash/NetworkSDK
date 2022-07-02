//
//  InferenceHistoryResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 05/06/22.
//

import Foundation

struct InferenceHistoryResponse: Decodable {
    
    struct Item: Decodable {
        var id: String
        var coordinates: String? //FIXME: What will the expected value
        var streamId: String? //FIXME: What will the expected value
        var inferenceType: String
        var useCase: String
        var image: String
        var metadata: [String: AnyValue]
    }
    var totalItems: Int
    var items: [Item]
    
}

extension InferenceHistoryResponse: CustomStringConvertible {
    var description: String {
        "InferenceHistoryResponse : \(totalItems)"
    }
}
