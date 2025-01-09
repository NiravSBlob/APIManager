//
//  UrlServiceConstant.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation

class UrlConstant{
    static let ResponseMessage = "message"
    
    //MARK:- Message Title
    static let Success = "Success"
    static let Failed = "Failed"
    static let Status = "status"
    static let SomethingWentWrong = "There is some server side error, Please try again after some time!"
    static let NoInternetConnection = "The Internet connection appears to be offline, Please connect to the internet."
}

let ErrorResponseDic = [UrlConstant.ResponseMessage: UrlConstant.SomethingWentWrong]
let NoInternetResponseDic = [UrlConstant.ResponseMessage: UrlConstant.NoInternetConnection]
