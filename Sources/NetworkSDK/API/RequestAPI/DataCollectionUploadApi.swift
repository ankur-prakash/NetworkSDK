//
//  DataCollectionUploadApi.swift
//  Backend
//
//  Created by Ankur Prakash on 07/06/22.
//

import Foundation

struct DataCollectionUploadApi {
    let data: Data
    let useCase: String
    let filename: String
}

extension DataCollectionUploadApi: NetworkApi {
    
    var identifier: RequestIdentifier {
        .dataCollectionUpload
    }
}
