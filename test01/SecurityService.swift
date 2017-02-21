//
//  SecurityService.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/21/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import Foundation

typealias LoginResponse = (String?, Error?) -> Void

class SecurityService: NSObject {

    static let sharedInstance = SecurityService()
    
    let protocolPrefix = "http://"
    let host = "topi.cafe"
    let port = "8080"
    let portSeparator = ":"
    let uri = "/chica/login"
    
    
    func login(username: String, password: String, onCompletion: @escaping (String?, Error?) -> Void) {
        let endpoint = protocolPrefix + host + portSeparator + port + uri
        
        requestLogin(username: username, password: password, path: endpoint, onCompletion: { result, error in
            onCompletion(result, error)
        })
    }
    
    private func requestLogin(username: String, password: String, path: String, onCompletion: @escaping LoginResponse) {
        
        let url = NSURL(string: path)
        var urlRequest = URLRequest(url: url as! URL)
        
        let params = "username=\(username)&password=\(password)"
        print("params: \(params)")
        
        urlRequest.httpBody=params.data(using: .utf8)
        urlRequest.httpMethod="POST"

        var result: String? = nil
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            
            print("### data: \(data)")
            print("### response: \(response)")
            print("### error: \(error)")
            
            if(error == nil ) {
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    let statusCode = httpResponse.statusCode
                    
                    if statusCode == 200 {
                        
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String : String], for: (response?.url)!)
                        
                        print("url: \(response?.url)")
                        print("cookies: \(cookies)")
                        
                        print("inicial \(HTTPCookieStorage.shared.cookies)")
                        
                        for cookie in cookies {
                            
                            var cookieProperties: [HTTPCookiePropertyKey: AnyObject] = [HTTPCookiePropertyKey: AnyObject]()
                            cookieProperties[HTTPCookiePropertyKey.name] = cookie.name as AnyObject?
                            cookieProperties[HTTPCookiePropertyKey.value] = cookie.value as AnyObject?
                            cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain as AnyObject?
                            cookieProperties[HTTPCookiePropertyKey.path] = cookie.path as AnyObject?
                            cookieProperties[HTTPCookiePropertyKey.version] = Double(cookie.version) as AnyObject?
                            cookieProperties[HTTPCookiePropertyKey.expires] = Date(timeIntervalSinceNow: 31536000) as AnyObject?
                            //                    cookieProperties[HTTPCookiePropertyKey.discard] = cookie.isSessionOnly as AnyObject?
                            
                            if let newCookie = HTTPCookie(properties: cookieProperties) {
                                print("name: \(cookie.name) value: \(cookie.value)")
                                HTTPCookieStorage.shared.setCookie(newCookie)
                                print("...added cookie: \(newCookie)")
                            } else {
                                print("NOT ADDED!!!")
                            }
                            
                            
                        }
                        
                        print("final \(HTTPCookieStorage.shared.cookies)")
                        result = "CHINGON"

                    } else if statusCode == 401 {
                        print("UNAUTHORIZED - Status code: \(statusCode)")
                        
                        let e = HttpRequestError.Unauthorized(reason: "UNAUTHORIZED - Status code: \(statusCode)")
                        onCompletion(result, e)
                        return
                        
                    } else {
                        
                        print("ERROR - Status code: \(statusCode)")
                        let e = HttpRequestError.HttpError(reason: "HTTP ERROR - Status code: \(statusCode)")
                        onCompletion(result, e)
                        return
                    }
                    
                }
                
            }
            
            onCompletion(result, error)
        }
        
        task.resume()
    }
    
    
    
}
