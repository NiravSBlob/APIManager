////
////  WebServicesSubclass.swift
////  BasicProject
////
////  Created by Nishee S on 15/12/21.
////
//
//import Foundation
//import UIKit
//

import SwiftyJSON

class WebServiceSubClass {
    
    
    class func getProfileAPI(completion: @escaping (Bool,RegisterResModel?,Any) -> ())
    {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.USER_PROFILE.rawValue, responseModel: RegisterResModel.self, completion: completion)
    }
    
    class func updateProfileAPI(reqModel : UpdateProfileReqModel, completion: @escaping (Bool,RegisterResModel?,Any) -> ())
    {
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.UPDATE_USER.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self,completion: completion)
    }
    
    class func registerUser(reqModel : RegisterReqModel, completion: @escaping (Bool,RegisterResModel?,Any) -> ())
    {
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.REGISTER.rawValue, requestModel: reqModel, responseModel: RegisterResModel.self,completion: completion)
    }
    
    class func getServerListAPI(reqModel : String, completion: @escaping (Bool,ServerListResponseModel?,Any) -> ())
    {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.SERVER_LIST.rawValue,requestModel: reqModel ,responseModel: ServerListResponseModel.self, completion: completion)
    }
    
//    class func lastServerLocationUpdate(reqModel : ServerConnectedReqModel, completion: @escaping (Bool,ServerConnectedResModel?,Any) -> ())
//    {
//        URLSessionRequestManager.makePostRequest(urlString: ApiKey.LAST_SERVER_CONNECT.rawValue, requestModel: reqModel, responseModel: ServerConnectedResModel.self, completion: completion)
//    } 
    
//    class func updateUserDataLimit(reqModel : UpdateUserDataLimitReqModel, completion: @escaping (Bool,UpdateUserDataLimitResModel?,Any) -> ())
//    {
//        URLSessionRequestManager.makePostRequest(urlString: ApiKey.UPDATE_USER_LIMIT.rawValue, requestModel: reqModel, responseModel: UpdateUserDataLimitResModel.self, completion: completion)
//    }
}
