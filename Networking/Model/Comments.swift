//
//  Comments.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import Foundation

struct Comments: Decodable {
    
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
    let imageUrl: String?
    
    init?(json: [String: Any]) {
        
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let email = json["email"] as? String
        let body = json["body"] as? String
        let imageUrl = json["imageUrl"] as? String
        
        self.id = id
        self.name = name
        self.email = email
        self.body = body
        self.imageUrl = imageUrl
    }
    
    static func getArray(from jsonArray: Any) -> [Comments]? {
        
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil}
        return jsonArray.compactMap { Comments(json: $0) }
    }
}
