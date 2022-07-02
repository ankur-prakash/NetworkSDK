//
//  File.swift
//  Backend
//
//  Created by Ankur Prakash on 04/05/22.
//

import Foundation

struct UseCasesResponse: Decodable {
    
    struct UseCase: Decodable , Encodable {
        
        var id: String
        var name: String
        var identifier: String
        var analyticsType: String
        
        init(id: String, name: String, identifier: String, analyticsType: String) {
            self.id = id
            self.name = name
            self.identifier = identifier
            self.analyticsType = analyticsType
        }
    }
    
    let useCases: [UseCase]
}
