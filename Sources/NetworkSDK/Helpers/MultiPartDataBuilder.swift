//
//  MultiPartDataBuilder.swift
//  Utils
//
//  Created by Ankur Prakash on 03/05/22.
//

import Foundation

public struct MultiPartDataBuilder {

    public static func createDataBody(data: Data,
                                      filename: String, boundary: String,
                                      withParameters params: [String: String] = [:])
    -> Data {
            var uploadData = Data()
            let lineBreak = "\r\n"
            uploadData.append("\(lineBreak)--\(boundary)\(lineBreak)")
        uploadData.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\(lineBreak)")
            uploadData.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)")
            uploadData.append(data)
            // add parameters
            for (key, value) in params {
                uploadData.append("\(lineBreak)--\(boundary)\(lineBreak)")
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)\(value)")
            }
            uploadData.append("\(lineBreak)--\(boundary)--\(lineBreak)")

        return uploadData
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
