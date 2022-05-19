//
//  ViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let jsonUrl = "https://jsonplaceholder.typicode.com/posts"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRequest(_ sender: Any) {
        
        guard let url = URL(string: jsonUrl) else { return }
        
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
    
    @IBAction func postRequest(_ sender: Any) {
        
        guard let url = URL(string: jsonUrl) else { return }
        
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
}

