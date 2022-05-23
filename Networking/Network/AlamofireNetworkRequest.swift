//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Sergey on 20.05.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completion: @escaping (_ comments: [Comments]) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        let request = AF.request(url, method: .get)
        
        request.validate().responseJSON { (response) in

            switch response.result {
                case .success(let value):
                    var comments = [Comments]()
                    comments = Comments.getArray(from: value)!
                    
                    completion(comments)
                    
                case .failure(let error):
                    print(error)
            }

        }
        
//        request.validate().responseDecodable(of: [Comments].self, decoder: JSONDecoder()) { response in
//
//            print(response)
//        }
    }
}
