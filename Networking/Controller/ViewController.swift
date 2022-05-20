//
//  ViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let jsonUrl = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImage = "https://api.imgur.com/3/image"
    
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
    
    @IBAction func uploadImageButton(_ sender: Any) {
        
        NetworkManager.uploadImage(url: uploadImage)
    }
    
}
