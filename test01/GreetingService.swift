//
//  GreetingService.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/20/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import Foundation

typealias GreetingsResponse = ([Greeting]?, Error?) -> Void
typealias GreetingResponse = (Greeting?, Error?) -> Void


class GreetingService: NSObject {
    
    static let sharedInstance = GreetingService()
    
    let protocolPrefix = "http://"
    let host = "topi.cafe"
    let port = "8080"
    let portSeparator = ":"
    let uri = "/chica/rest/greetings"
    
    func list(onCompletion: @escaping ([Greeting]?, Error?) -> Void) {
        let endpoint = protocolPrefix + host + portSeparator + port + uri
        
        requestList(path: endpoint, onCompletion: { greetings, error in
            onCompletion(greetings! as [Greeting], error)
        })
        
    }
    
    func get(name: String, onCompletion: @escaping (Greeting?, Error?) -> Void) {
        let endpoint = protocolPrefix + host + portSeparator + port + uri + "/" + name
        
        requestGreet(path: endpoint, onCompletion: { greet, error in
            onCompletion(greet, error)
        })
        
    }

    
    private func requestList(path: String, onCompletion: @escaping GreetingsResponse) {
        
        var greetings: [Greeting] = []
        let url = NSURL(string: path)
        var urlRequest = URLRequest(url: url as! URL)
        let cookies = HTTPCookieStorage.shared.cookies
        let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies!)
        
        for cookieHeader in cookieHeaders {
            urlRequest.addValue(cookieHeader.value, forHTTPHeaderField: "Cookie")
        }
        urlRequest.httpMethod="GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            
            print("### data: \(data)")
            print("### response: \(response)")
            print("### error: \(error)")
            
            if(error == nil ) {
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    let statusCode = httpResponse.statusCode
                    
                    if statusCode == 200 {
                        
                        let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data!, options: [])
                        print("### jsonWithObjectRoot: \(jsonWithObjectRoot)")
                        
                        let greetingsJson = jsonWithObjectRoot as? [Any]
                        
                        for greetJson in greetingsJson! {
                            if let greetItem = greetJson as? [String: Any] {
                                if let greet = try? Greeting(json: greetItem) {
                                    
                                    print("### adding")
                                    greetings.append(greet!)
                                }
                            }
                        }
                        
                        print("######################")
                        print("### greetings: \(greetings)")
                        print("######################")
                    
                    } else if statusCode == 401 {
                        print("UNAUTHORIZED - Status code: \(statusCode)")
                        
                        let e = HttpRequestError.Unauthorized(reason: "UNAUTHORIZED - Status code: \(statusCode)")
                        onCompletion(greetings, e)
                        return
                        
                    } else {
                        
                        print("ERROR - Status code: \(statusCode)")
                        let e = HttpRequestError.HttpError(reason: "HTTP ERROR - Status code: \(statusCode)")
                        onCompletion(greetings, e)
                        return
                    }
                }
                
            }
            
            onCompletion(greetings, error)

        }
        
        task.resume()
    }
    
    private func requestGreet(path: String, onCompletion: @escaping GreetingResponse) {
        
        var greet: Greeting? = nil
        let url = NSURL(string: path)
        var urlRequest = URLRequest(url: url as! URL)
        let cookies = HTTPCookieStorage.shared.cookies
        let cookieHeaders = HTTPCookie.requestHeaderFields(with: cookies!)
        
        for cookieHeader in cookieHeaders {
            urlRequest.addValue(cookieHeader.value, forHTTPHeaderField: "Cookie")
        }
        urlRequest.httpMethod="GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            
            print("### data: \(data)")
            print("### response: \(response)")
            print("### error: \(error)")
            
            
            if(error == nil ) {
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    let statusCode = httpResponse.statusCode
                    
                    if statusCode == 200 {
                        let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data!, options: [])
                        print("### jsonWithObjectRoot: \(jsonWithObjectRoot)")
                        
                        
                        if let dictionary = jsonWithObjectRoot as? [String: Any] {
                            
                            print("json OK")
                            
                            if let g = try? Greeting(json: dictionary) {
                                
                                print("object OK")
                                greet = g
                            }
                            
                        }
                        
                        print("######################")
                        print("### greet: \(greet)")
                        print("######################")
                       
                       
                    } else if statusCode == 401 {
                        print("UNAUTHORIZED - Status code: \(statusCode)")
                        
                        let e = HttpRequestError.Unauthorized(reason: "UNAUTHORIZED - Status code: \(statusCode)")
                        onCompletion(greet, e)
                        return
                        
                    } else {
                        
                        print("ERROR - Status code: \(statusCode)")
                        let e = HttpRequestError.HttpError(reason: "HTTP ERROR - Status code: \(statusCode)")
                        onCompletion(greet, e)
                        return
                    }
                }
            }
            
            onCompletion(greet, error)
        }
        task.resume()
    }
    
    
}
