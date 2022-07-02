//
//  DataCollectionDeleteApi.swift
//  Backend
//
//  Created by Ankur Prakash on 08/06/22.
//

import Foundation

struct DataCollectionDeleteApi {
    let imageId: String
}

extension DataCollectionDeleteApi: NetworkApi {
    var identifier: RequestIdentifier { .dataCollectionDelete }
}
