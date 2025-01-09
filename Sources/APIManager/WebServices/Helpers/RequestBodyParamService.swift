//
//  RequestBodyParamService.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation

class RequestBodyClass{
    
    class func createDataBodyForMediaRequest(withParameters params: [String: Any]?, media: [UploadMediaModel]?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                let valueStr = value as? String ?? ""
                body.append("\(valueStr + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}
