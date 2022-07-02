//
//  File.swift
//  Backend
//
//  Created by Ankur Prakash on 04/05/22.
//

import Foundation

public struct AnyNetworkApi: NetworkApi {
    
    public var identifier: RequestIdentifier
    init(_ identifier: RequestIdentifier) {
        self.identifier = identifier
    }
}
