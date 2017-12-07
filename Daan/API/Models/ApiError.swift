//
//  Error.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import Foundation
import ObjectMapper

struct ApiError: Mappable {
    var code: Int?
    var error: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code   <- map["code"]
        error  <- map["error"]
    }
}
