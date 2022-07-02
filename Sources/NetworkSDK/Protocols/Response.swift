//
//  Response.swift
//  RequestSDK
//
//  Created by Ankur Prakash on 28/05/22.
//

import Foundation

public protocol Response {
   var status: Int { get }
   var request: Request { get }
   var data: Data { get }
   var urlResponse: URLResponse { get }
}
