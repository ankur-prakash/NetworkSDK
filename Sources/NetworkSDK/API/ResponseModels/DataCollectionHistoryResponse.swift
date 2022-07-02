//
//  DataCollectionHistoryResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 08/06/22.
//

import Foundation

struct DataCollectionHistoryResponse: Decodable {
    
    struct Record: Decodable {
        var id: String
        var image: String
        var createdAt: String
    }
    
    var totalItems: Int
    var items: [Record]
}
