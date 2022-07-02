//
//  LoginApi.swift
//  Backend
//
//  Created by Ankur Prakash on 01/07/22.
//

import Foundation

struct LoginApi {
    
    let email: String
    let password: String
}

extension LoginApi: NetworkApi {
    
    var identifier: RequestIdentifier { .login }
}
