//
//  URLSessionRequestManager.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation
import UIKit
import SystemConfiguration

public typealias CompletionResponse<R:Codable> = (Bool,Codable?,Any) -> ()
public class URLSessionRequestManager {
    
    static func BEARER_HEADER() -> [String:String]{
        return APIEnvironment.headers
    }
    
    public class func makeGetRequest<C:Codable>(urlString: String, requestModel: String? = nil,responseModel: C.Type, completion: @escaping (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()) {
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
       let strURL = APIEnvironment.baseURL + urlString
        
        guard let url = URL(string: strURL) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        var request = URLRequest(url: url)
        
        if let bodyDic = requestModel{
            guard let url = URL(string: strURL + "?\(bodyDic)") else {
                completion(false, nil, ErrorResponseDic)
                return
            }
            
            request = URLRequest(url: url)
        
            print("***********************************************")
            print("PARAMETERS ==> \(url)")
            print("PARAMETERS ==> \(bodyDic)")
        }
        
        
      
        
        request.httpMethod = GetRequestType.GET.rawValue
      
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        
        
        print("***********************************************")
        print("URL ==> \(url)")
        print("***********************************************")
        print("HEADERS ==> \(BEARER_HEADER())")
        print("***********************************************")
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            DispatchQueue.main.async {
                completion(status,obj,dic)
            }
           
        }
    }
    
    class func makePostRequest<C:Codable, P:Encodable>(urlString: String, requestModel: P, responseModel: C.Type, completion: @escaping (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()) {
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, nil, ErrorResponseDic)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
            
            print("***********************************************")
            print("URL ==> \(url)")
            print("***********************************************")
            print("PARAMETERS ==> \(bodyDic)")
            print("***********************************************")
            print("HEADERS ==> \(BEARER_HEADER())")
            print("***********************************************")
        }
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            completion(status,obj,dic)
        }
    }
    
    class func makeImageUploadRequest<C:Codable, P:Codable>(urlString: String, requestModel: P, responseModel: C.Type, image: UIImage, imageKey: String, completion: @escaping (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()) {
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: image) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
            
        print("***********************************************")
        print("URL ==> \(url)")
        print("***********************************************")
        print("PARAMETERS ==> \(paramaterDic)")
        print("***********************************************")
        print("HEADERS ==> \(BEARER_HEADER())")
        print("***********************************************")
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            completion(status,obj,dic)
        }
    }
    
    class func makeMultipleImageRequest<C:Codable, P:Codable>(urlString: String, requestModel: P, responseModel: C.Type, imageKey: String ,arrImageData : [UIImage]?, completion: @escaping (_ status: Bool,_ modelObj: Any?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        var mediaArr = [UploadMediaModel]()
        if let dataDic = arrImageData{
            for each in dataDic{
                guard let mediaImage = UploadMediaModel(mediaType: .Image, forKey: imageKey, withImage: each) else {
                    completion(false, nil, ErrorResponseDic)
                    return
                }
                mediaArr.append(mediaImage)
            }
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            completion(status,obj,dic)
        }
    }
    
    class func makeMediaUploadRequest<C:Codable, P:Codable>(urlString: String, requestModel: P, responseModel: C.Type, mediaType: MediaType,file_url: String, fileKey: String, completion: @escaping (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        guard let mediaUrl = URL(string: file_url) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        guard let mediaImage = UploadMediaModel(mediaType: mediaType, forKey: fileKey, fileUrl: mediaUrl) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        print("REQUEST: \(request)")
        print("***********************************************")
        print("URL ==> \(url)")
        print("***********************************************")
        print("PARAMETERS ==> \(paramaterDic)")
        print("***********************************************")
        print("HEADERS ==> \(BEARER_HEADER())")
        print("***********************************************")
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            completion(status,obj,dic)
        }
    }
    
    class func makeMultipleMediaUploadRequest<C:Codable, P:Codable>(urlString: String, requestModel: P, responseModel: C.Type, mediaArr: [UploadMediaModel], completion: @escaping (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()){
        var paramaterDic = [String: Any]()
        
        if !Reachability.isConnectedToNetwork() {
            completion(false, nil, NoInternetResponseDic)
            return
        }
        
        guard let url = URL(string: APIEnvironment.baseURL + urlString) else {
            completion(false, nil, ErrorResponseDic)
            return
        }
        
        let boundary = RequestString.boundry.rawValue + "\(NSUUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = GetRequestType.POST.rawValue
        request.allHTTPHeaderFields = BEARER_HEADER()
        
        if let bodyDic = try? requestModel.asDictionary(){
            paramaterDic = bodyDic
            let dicData = bodyDic.percentEncoded()
            request.httpBody = dicData
        }
        
        request.setValue(RequestString.multiplePartFormData.rawValue + boundary, forHTTPHeaderField: RequestString.contentType.rawValue)
        
        let dataBody = RequestBodyClass.createDataBodyForMediaRequest(withParameters: paramaterDic, media: mediaArr, boundary: boundary)
        
        print("BODY DIC: \(paramaterDic)")
        request.httpBody = dataBody
            
        print("the url is \(url) and the parameters are \n \(paramaterDic) and the headers are \(BEARER_HEADER())")
        
        print("REQUEST: \(request)")
        
        CodableService.shared.getResponseFromSession(request: request, codableObj: responseModel) { (status, obj, dic) in
            completion(status,obj,dic)
        }
    }
}


