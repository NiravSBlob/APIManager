//
//  ApiPaths.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation

typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum APIEnvironment : String {
    
    case Development = "https://api.gamingvpn.tech/v2/"
    case Live = ""
    
    static var baseURL: String {
        return APIEnvironment.environment.rawValue
    }
    
    static var environment: APIEnvironment {
        return .Development
    }
    
    static var headers : [String:String]
    {
        var headers: [String:String]
        headers = [:]
//        if defaults.object(forKey: kAuthToken) != nil {
//            headers = [
//                "Authorization": "\(defaults.object(forKey: kAuthToken) as! String)"
//            ]
//        }
        return headers
    }
}
enum GetRequestType: String{
    case GET
    case POST
    case DELETE
}

enum RequestString : String{
    case boundry = "Boundary-"
    case multiplePartFormData = "multipart/form-data; boundary="
    case contentType = "Content-Type"
}



