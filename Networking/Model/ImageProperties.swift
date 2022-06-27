//
//  ImageProperties.swift
//  Networking
//
//  Created by Sergey on 20.05.2022.
//

import Foundation
import UIKit


struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
