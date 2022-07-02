//
//  LoginResponse.swift
//  Backend
//
//  Created by Ankur Prakash on 07/05/22.
//

import Foundation

public struct LoginResponse: Decodable {
    
    public var status: String?
    public var accessToken: String
    public var refreshToken: String
    
    static func empty() -> LoginResponse { Self(status: "", accessToken: "", refreshToken: "") }
}

public struct LoginResponseFail: Decodable {
    
    public var status: String
    public var message: String
}
