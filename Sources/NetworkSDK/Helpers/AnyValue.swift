//
//  AnyValue.swift
//  Backend
//
//  Created by Ankur Prakash on 06/06/22.
//

import Foundation

enum AnyValue: Decodable {
    
    case int(Int), string(String), double(Double)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        throw ValueError.missingValue
    }
    
    var stringValue: String {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let value):
            return value
        case .double(let value):
            return String(value)
        }
    }
    
    enum ValueError:Error {
        case missingValue
    }
}
