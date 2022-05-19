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
        
        NetworkManager.getRequest(url: jsonUrl)
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        NetworkManager.postRequest(url: jsonUrl)
    }
    
}
