//
//  RefreshTokenApi.swift
//  Backend
//
//  Created by Ankur Prakash on 01/07/22.
//

import Foundation

struct RefreshTokenApi {
    let refreshToken: String
}

extension RefreshTokenApi: NetworkApi {
    var identifier: RequestIdentifier { .refreshtoken }
}
