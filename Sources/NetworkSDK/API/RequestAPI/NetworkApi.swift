//
//  Request.swift
//  Backend
//
//  Created by Ankur Prakash on 02/05/22.
//

import Foundation

public protocol NetworkApi {
    var identifier: RequestIdentifier { get }
}
