//
//  ImageUploadRequest.swift
//  Backend
//
//  Created by Ankur Prakash on 02/05/22.
//

import Foundation
import SwiftUI

struct ImageUploadRequest {
    
    let data: Data
    let height: Int
    let width: Int
    let useCase: String
    let boundingBox: Bool
    let filename: String
    
    init(data: Data, width: Int,
         height: Int, useCase: String, boundingBox: Bool, filename: String) {
        self.data = data
        self.width = width
        self.height = height
        self.useCase = useCase
        self.boundingBox = boundingBox
        self.filename = filename
    }
}

extension ImageUploadRequest: NetworkApi {
    
    public var identifier: RequestIdentifier {
        return .imageUpload
    }
}
