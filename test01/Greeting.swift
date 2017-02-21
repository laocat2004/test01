//
//  Greeting.swift
//  test01
//
//  Created by Luis Topiltzin Dominguez Butron on 12/18/16.
//  Copyright © 2016 Luis Topiltzin Dominguez Butron. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct Greeting {
    
    let creationDate: Date
    let greet: String
    let id: UUID
    let user: String
    
}

extension Greeting {
    
    init?(json: [String: Any]) throws {
    
        guard let greet = json["greet"] as? String else {
            throw SerializationError.missing("greet")
        }
        
        guard let user = json["user"] as? String else {
            throw SerializationError.missing("user")
        }

        
        guard let date = json["creationDate"] as? Double else {
            print("ERROR  date")
            throw SerializationError.missing("creationDate")
        }
        
        let creationDate = Date(timeIntervalSince1970: date)

        guard let idString = json["id"] as? String else {
            
            print("ERROR  UUID")
            throw SerializationError.missing("id")
        }
        
        let id = UUID(uuidString: idString)
    
        self.creationDate = creationDate
        self.greet = greet
        self.id = id!
        self.user = user
        
    }
    
    
}
