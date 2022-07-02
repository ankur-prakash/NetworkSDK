//
//  AnalyzedHistroyApi.swift
//  Backend
//
//  Created by Ankur Prakash on 05/06/22.
//

import Foundation

struct InferenceHistoryApi {
    
    let boundingBox: Bool
    let page: Int
    let useCase: String
}

extension InferenceHistoryApi: NetworkApi {
    
    public var identifier: RequestIdentifier {
        return .fetchInferenceHistory
    }
}
