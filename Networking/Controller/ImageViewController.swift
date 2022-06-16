//
//  ImageViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let jpgUrl = "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        completedLabel.isHidden = true
        progressView.isHidden = true

    }
    
    func fetchImage() {
        
        NetworkManager.downloadImage(url: jpgUrl) { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
        }
    }
    
    func fetchImageWithAlamofire() {

        AlamofireNetworkRequest.onProgress = { [weak self] progress in
            
            self?.progressView.isHidden = false
            self?.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { [weak self] completed in
            
            self?.completedLabel.isHidden = false
            self?.completedLabel.text = completed
        }
        
        AlamofireNetworkRequest.downloadImageWithProgress(url: jpgUrl) { [weak self] image in
            
            self?.activityIndicator.stopAnimating()
            self?.completedLabel.isHidden = true
            self?.progressView.isHidden = true
            self?.imageView.image = image
            
            
        }
    }
}
