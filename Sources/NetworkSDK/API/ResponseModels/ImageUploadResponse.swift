//
//  ImageUploadResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 04/05/22.
//

import Foundation


struct ImageUploadResponse: Decodable {
    
    struct Coordinate: Decodable {
        var label: String
        var coordinates: [Double]
    }
    
    var status: String
    var metadata: [String: AnyValue]
    var coordinates: [Coordinate]?
    var image: String?
}
