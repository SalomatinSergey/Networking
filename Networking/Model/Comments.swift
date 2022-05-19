//
//  Comments.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import Foundation

struct Comments: Decodable {
    
    let id: Int
    let name: String
    let email: String?
    let body: String?
    let imageUrl: String?
}
