//
//  HttpRequestError.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/22/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import Foundation

enum HttpRequestError : Error {
    case Unauthorized(reason: String)
    case HttpError(reason: String)
    
    func errorInfo() -> String? {
        
        var errorString:String?
        
        switch self {
        case .Unauthorized(let reason):
            print("unauthorized")
            errorString = reason
        case .HttpError(let reason):
            print("httperror")
            errorString = reason
        }
        
        return errorString
    }
    
}
