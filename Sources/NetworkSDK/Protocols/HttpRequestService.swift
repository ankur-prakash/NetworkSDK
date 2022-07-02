//
//  HttpRequestServiceDuplicate.swift
//  Backend
//
//  Created by Ankur Prakash on 10/06/22.
//

import Foundation

import Combine

public protocol HttpRequestService {
    func enqueueRequest(_ request: Request) -> AnyPublisher<AnyResponse, Error>
    func rescheduleWithNewToken(_ accessToken: String)
    var requestDidUnAuthorized: AnyPublisher<Void, Never> { get }
    var fatalErrorOccurred: AnyPublisher<Void, Never> { get }    
}
