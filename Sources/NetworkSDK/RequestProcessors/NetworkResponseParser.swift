//
//  NetworkResponseParser.swift
//  Backend
//
//  Created by Ankur Prakash on 04/05/22.
//

import Foundation
import Combine

final class NetworkResponseParser {
    
    //fileprivate property can be used in extensions for other classes
    fileprivate static func _parseResponse<Success, Fail>(
        success: (Set<Int>, item: Success.Type),
        fail: Fail.Type,
        for response: Response,
        decoder: JSONDecoder) throws
    
    -> Success where Success: Decodable, Fail: Decodable & FailureResponse {
        
        guard success.0.contains(response.status) else {
            do {
                let failure = try decoder.decode(fail, from: response.data)
                throw BackendError.genericError(failure.error)
            } catch {
                throw error
            }
        }
        do {
            return try decoder.decode(success.item, from: response.data)
        } catch {
            throw error
        }
    }
}

extension Publisher where Output: Response {
    
    func parseResponse<Success,Fail>(success: (Set<Int>, item: Success.Type), fail: Fail.Type,
                                     decoder: JSONDecoder)
    throws -> AnyPublisher<Success, Error> where Success: Decodable, Fail: Decodable & FailureResponse {

        tryMap { try NetworkResponseParser._parseResponse(success: success, fail: fail, for: $0, decoder: decoder) }
        .eraseToAnyPublisher()
    }
}
