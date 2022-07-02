//
//  DataCollectionHistoryAPi.swift
//  Backend
//
//  Created by Ankur Prakash on 08/06/22.
//

import Foundation

typealias UseCaseIdentifier = String

struct DataCollectionHistoryApi {
    
    let useCase: UseCaseIdentifier
    let page: Int
    let startDate: Date?
    let endDate: Date?
}

extension DataCollectionHistoryApi: NetworkApi {
  
    var identifier: RequestIdentifier { .dataCollectionHistory }
}
