//
//  File.swift
//  
//
//  Created by Ankur Prakash on 02/07/22.
//

import Foundation

enum BackendError: Error {
    case genericError(_ reason: String)
    case invalidUrl
}
