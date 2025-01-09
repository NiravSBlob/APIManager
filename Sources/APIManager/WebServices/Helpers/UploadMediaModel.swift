//
//  UploadMediaModel.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation
import UIKit

class UploadMediaModel: Codable {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(mediaType: MediaType, forKey key: String, withImage image: UIImage? = nil, fileUrl url: URL? = nil) {
        self.key = key
        let ext = mediaType.rawValue == MediaType.Audio.rawValue ? "m4a" : (url?.pathExtension ?? "")
        self.mimeType = mediaType.rawValue == MediaType.Image.rawValue ? "image/jpg" : "\(mediaType.rawValue)/\(ext)"
        self.fileName = mediaType.rawValue == MediaType.Image.rawValue ? "image.jpeg" : "\(key).\(ext.lowercased())"
        
        var mediaData : Data?
        if mediaType.rawValue == MediaType.Image.rawValue{
           if let img = image{
                guard let data = img.jpegData(compressionQuality: 0.5) else { return nil }
                mediaData = data
           }
        }else{
            if let mediaUrl = url{
                guard let data = try? Data(contentsOf: mediaUrl)else { return nil }
                mediaData = data
            }
        }
        
        guard let dt = mediaData else { return nil}
        self.data = dt
    }
}

enum MediaType: String{
    case Image = "image"
    case Video = "video"
    case Audio = "audio"
    case File = "application"
}
