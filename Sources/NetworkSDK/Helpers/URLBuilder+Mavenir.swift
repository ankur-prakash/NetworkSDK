//
//  URLBuilder+Mavenir.swift
//  Utils
//
//  Created by Ankur Prakash on 29/04/22.
//

import Foundation
//ec2-18-189-59-20.us-east-2.compute.amazonaws.com
public extension URLBuilder {
    enum HostServer: String {
        case mavenirTestServer = "ec2-3-141-193-122.us-east-2.compute.amazonaws.com"
    }
    
    static func build(parameters: [String:String] = [:], path: Path) -> URL? {
        URLBuilder.build(parameters: parameters, protocolType: .https, host: .host(HostServer.mavenirTestServer.rawValue), path: path, port: 3032)
    }
}
