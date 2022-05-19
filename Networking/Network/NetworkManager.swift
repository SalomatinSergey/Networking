//
//  NetworkManager.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit

class NetworkManager {
    
    static func getRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            
            guard let response = response, let data = data else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
                
            }
            
        }.resume()
    }
    
    static func postRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let userData = ["Task": "Networking", "FrameWork": "URLSession"]
        
        var requset = URLRequest(url: url)
        requset.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        
        requset.httpBody = httpBody
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: requset) { data, response, error in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func fetchData(url: String, completion: @escaping (_ comments: [Comments]) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let comments = try decoder.decode([Comments].self, from: data)
                
                completion(comments)
                
            } catch {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
    
}
