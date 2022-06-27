//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Sergey on 20.05.2022.
//

import Foundation
import Alamofire
import UIKit

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double) -> ())?
    static var completed : ((String) -> ())?
    
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
    }
    
    
    static func downloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage)-> ()) {
        
        guard let url = URL(string: url) else { return }
        
        let request = AF.request(url)
        request.validate().downloadProgress { (progress) in
            
            print("totalUnnitCount: \(progress.totalUnitCount)")
            print("completedUnitCount: \(progress.completedUnitCount)")
            print("fractionCompleted: \(progress.fractionCompleted)")
            print("localizedDescription: \(progress.localizedDescription!)")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
            
        }.response { (response) in
            
            guard let data = response.data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
//    static func responseData(url: String) {
//
//        let request = AF.request(url, method: .get)
//        request.responseData { (responseData) in
//
//            switch responseData.result {
//                case .success(let data):
//                    print(data)
//                case .failure(let error):
//                    print(error)
//            }
//        }
//    }
    
//    static func responseString(url: String) {
//
//        let request = AF.request(url, method: .get)
//        request.responseString { (responseString) in
//
//            switch responseString.result {
//                case .failure(let error):
//                    print(error)
//                case .success(let string):
//                    print(string)
//            }
//
//        }
//    }
//
//    static func response(url: String) {
//
//        let request = AF.request(url, method: .get)
//        request.response { (response) in
//
//            guard let data = response.data, let string = String(data: data, encoding: .utf8) else { return }
//
//            print(string)
//        }
//    }
    
    static func postRequest(url: String, completion: @escaping (_ comments: [Comments]) -> ()) {
        
        guard let url = URL(string: url) else { return }
        let userData: [String: Any] = ["name": "Sergey",
                                       "email": "salomatinsv8@gmail.com",
                                       "body": "est natus enim nihil est dolore omnis voluptatem numquam" +
                                       "\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur" +
                                       "\nnihil sint nostrum voluptatem reiciendis et"]
        
        let request = AF.request(url, method: .post, parameters: userData)
        request.responseJSON { (responseJSON) in
            
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("Status code:", statusCode)
            
            switch responseJSON.result {
                case .success(let value):
                    print(value)
                    
                    guard let jsonObject = value as? [String: Any],
                          let comment = Comments(json: jsonObject)
                    else { return }
                    
                    var comments = [Comments]()
                    comments.append(comment)
                    
                    completion(comments)
                case .failure(let error):
                    print(error)
                    
            }
        }
    }
    
    static func uploadImage(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let image = UIImage(named: "fruits")!
        let data = image.pngData()!
        let httpHeaders : HTTPHeaders = ["Authorization": "Client-ID \(Imgur.client.Id)"]
        
        
        let uploadRequest = AF.request(url, method: .post)
        
        _ = AF.upload(multipartFormData: { (multiplatformData) in

            multiplatformData.append(data, withName: "image")

        }
                               , to: url
                               , headers: httpHeaders) { (encodingCompletion) in
            
            uploadRequest.validate().responseJSON { (responseJson) in
                
                switch responseJson.result {
                    case .failure(let error):
                        print(error)
                        
                    case .success(let value):
                        print(value)
                        
                }
            }
            
        }
    }
}
