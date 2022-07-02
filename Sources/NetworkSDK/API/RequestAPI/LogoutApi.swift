//
//  LogoutApi.swift
//  Backend
//
//  Created by Ankur Prakash on 01/07/22.
//

import Foundation

struct LogoutApi {
    let accessToken: String
}

extension LogoutApi: NetworkApi {
    var identifier: RequestIdentifier { .logout }
}
