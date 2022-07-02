//
//  RequestLogger.swift
//  Backend
//
//  Created by Ankur Prakash on 12/06/22.
//

import Foundation

class RequestLogger {

    static func log(_ request: Request) {
        
        let urlString = request.urlRequest.url?.absoluteString ?? "URL Missing"
        NSLog("=========\nRequest: \(request.identifier)::\nURL: \(urlString) \nMethod: \(request.urlRequest.httpMethod ?? "No Http Method"))\nRequestHeaders: \(request.urlRequest.allHTTPHeaderFields ?? [:])\n=========")
    }
    
    static func log(_ response: Response) {
        
        let fileSize = Double(response.data.count / 1048576) //Convert in to MB
        guard !RequestLogger.excludeLogging(response.request.identifier) else {
            NSLog("=========\nResponse: \(response.request.identifier):: Status Code: \(response.status)\nResponseData:\r Data not needed to be printed in the log = \(fileSize) MB\n=========")
            return
        }
        guard fileSize <= 1.0 else {
            NSLog("=========\nResponse: \(response.request.identifier):: Status Code: \(response.status)\nResponseData:\r Data too long = \(fileSize) MB\n=========")
            return
        }
        NSLog("=========\nResponse: \(response.request.identifier):: Status Code: \(response.status)\nResponseData:\r\(String(data: response.data, encoding: .utf8) ?? "No Data")\n=========")
    }
    
    static func log(_ request: Request, withError error: Error) {
        
        NSLog("=========\nResponse: \(request.identifier):: Description: \((error as? URLError)?.errorCode ?? -1)\nError:\r\(error))\n=========")
    }
    
    static func log( _ message: String) {
        NSLog(message)
    }
}

extension RequestLogger {
    
    static func excludeLogging( _ identifier: RequestIdentifier) -> Bool {
        Set([.fetchInferenceHistory, .dataCollectionHistory]).contains(identifier)
    }
}
