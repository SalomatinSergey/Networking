//
//  ImageViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    let jpgUrl = "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
        
    }
    
    func fetchImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: jpgUrl) { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
        }
    }

}
