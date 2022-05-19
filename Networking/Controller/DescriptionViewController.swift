//
//  DescriptionViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit
import WebKit

class DescriptionViewController: UIViewController {
    
    var selectedCourse: String?
    var commentUrl = ""

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressVIew: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCourse
        
        guard let url = URL(string: commentUrl) else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        print("KEK")
    }

}

extension UIViewController: WKNavigationDelegate {
    
}
