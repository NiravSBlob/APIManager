//
//  CodableResponseServiceClass.swift
//  BasicProject
//
//  Created by Nishee S on 15/12/21.
//

import Foundation

class CodableService: NSObject {
    
    static let shared = CodableService()
    private let certificates: [Data] = {
            let url = Bundle.main.url(forResource: "server_certificate", withExtension: "cer")!
            let data = try! Data(contentsOf: url)
            return [data]
          }()
    
    lazy var session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    
    func getResponseFromSession<C:Codable>(request: URLRequest, codableObj: C.Type, completion: @escaping  (_ status: Bool,_ modelObj: C?,_ dataDic: Any) -> ()){
        
        var responseDic = [String:Any]()
        
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let ERR = error{
                    if ERR.localizedDescription.lowercased() == "cancelled".lowercased(){
                        completion(false, nil, "Looks like another proxy server is currently running on your device. To continue using the application, please turn off the proxy server.")
                    }else {
                        completion(false, nil, ERR.localizedDescription)
                    }
                  
                }else{
                    if let httpResponse = response as? HTTPURLResponse{
                        print("Status code of the request:=>",httpResponse.statusCode)
                        var statusCode = httpResponse.statusCode == 200
                        if httpResponse.statusCode == 200{
                            if  let responseData = data {
                                responseDic = CodableService.getResponseDicFromData(responseData: responseData)
                                if let APIStatus = responseDic[UrlConstant.Status] as? Bool {
                                    statusCode = APIStatus
                                }
                                if let obj = CodableService.getCodableObjectFromData(jsonData: responseData, codableObj: codableObj){
                                    completion(statusCode, obj, responseDic)
                                }else{
                                    completion(statusCode, nil, responseDic)
                                }
                            }else{
                                completion(statusCode, nil, ErrorResponseDic)
                            }
                        }else if httpResponse.statusCode == 403{
                            //Do Force Logout
                            completion(statusCode, nil, ErrorResponseDic)
                        }else{
                            completion(statusCode, nil, ErrorResponseDic)
                        }
                    }
                }
            }
        }.resume()
    }
    
    class func getCodableObjectFromData<C:Codable>(jsonData: Data, codableObj: C.Type) -> C?{
        do {
            let obj = try JSONDecoder().decode(codableObj, from: jsonData)
            return obj
        } catch(let error) {
            print(error)
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func getResponseDicFromData(responseData: Data) -> [String:Any]{
        var responseDic = [String:Any]()
        let jso = try? JSONSerialization.jsonObject(with: responseData)
        
        
        if let jsonObj = jso, let mainDic = jsonObj as? [String: Any]{
            responseDic = mainDic
        }else{
            responseDic = ErrorResponseDic
        }
        
        if let desiredString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
        {
            print("****************** Response ******************")
            print(desiredString)
            print("***********************************************")
        }
        
        print("The webservice call response \n \(responseDic)")
        
        return responseDic
    }
}

extension CodableService : URLSessionDelegate {
    // Implement URLSessionDelegate methods as needed
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
           if let trust = challenge.protectionSpace.serverTrust,
              SecTrustGetCertificateCount(trust) > 0 {
               if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                   let data = SecCertificateCopyData(certificate) as Data
                   
                   if certificates.contains(data) {
                       completionHandler(.useCredential, URLCredential(trust: trust))
                       return
                   } else {
                       //TODO: Throw SSL Certificate Mismatch
                       completionHandler(.cancelAuthenticationChallenge, nil)
                       return
                   }
               }
               
           }
           completionHandler(.cancelAuthenticationChallenge, nil)
       }
}
