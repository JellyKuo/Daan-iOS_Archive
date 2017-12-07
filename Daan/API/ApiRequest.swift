//
//  ApiRequest.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/11.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import Alamofire

class ApiRequest{
    typealias JSONDictionary = [String: Any]
    typealias JSONArray = [JSONDictionary]
    let baseUrl:String
    let requestUrl:String
    let method:HTTPMethod
    let token:Token?
    let params:JSONDictionary
    
    init(path:String,method:HTTPMethod,token:Token? = nil,params:JSONDictionary? = nil) {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVersion = apiConfig?.object(forKey: "ApiVersion") as! String
        self.baseUrl = "https://"+apiUrl+"/"+apiVersion+"/"
        self.requestUrl = baseUrl+path
        self.method = method
        self.token = token
        if let parameters:JSONDictionary = params{
            self.params = parameters
        }
        else{
            self.params = [:]
        }
        
    }
    
    func request(result : @escaping (JSONDictionary?,ApiError?,Error?) -> Void) {
        print("Running ApiRequest towards url: \(self.requestUrl)")
        let headers:HTTPHeaders?
        if let tk = token{
            headers = ["Authorization":tk.token!]
        }
        else{
            headers = [:]
        }
        
        Alamofire.request(requestUrl, method: self.method, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .responseJSON {
                response in
                switch response.result{
                case .success(let val):
                    let value = val as! JSONDictionary
                    if value["code"] == nil{
                        result(value,nil,nil)
                    }
                    else{
                        let apiError = ApiError(JSON: value)
                        print("Api reported error!\n  Code: \(apiError?.code ?? -1)\n  Error:\(apiError?.error ?? "")")
                        result(nil,apiError,nil)
                    }
                    
                case .failure(let error):
                    print("Alamofire Error\n  \(error)")
                    result(nil,nil,error)
                }
        }
    }
    
    //TODO: Create a better implementation when data is sent as array
    
    func requestArr(result : @escaping (JSONArray?,ApiError?,Error?) -> Void) {
        print("Running ARRAY ApiRequest towards url: \(self.requestUrl)")
        let headers:HTTPHeaders?
        if let tk = token{
            headers = ["Authorization":tk.token!]
        }
        else{
            headers = [:]
        }
        
        Alamofire.request(requestUrl, method: self.method, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .responseJSON {
                response in
                switch response.result{
                case .success(let val):
                    if let value = val as? JSONDictionary{
                        let apiError = ApiError(JSON: value)
                        print("(Array) Api reported error!\n  Code: \(apiError?.code ?? -1)\n  Error:\(apiError?.error ?? "")")
                        result(nil,apiError,nil)
                    }
                    else{
                        let value = val as! JSONArray
                        result(value,nil,nil)
                    }
                case .failure(let error):
                    print("Alamofire Error (ARRAY)\n  \(error)")
                    result(nil,nil,error)
                }
        }
    }
    
}

