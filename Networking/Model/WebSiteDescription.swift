//
//  WebSiteDescription.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import Foundation

struct WebsiteDescription: Decodable {
    
    let websiteDescription: String
    let websiteName: String
    let comments: [Comments]
}
