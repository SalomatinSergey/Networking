//
//  ViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    private let jsonUrl = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImage = "https://api.imgur.com/3/image"
    private var alertController: UIAlertController!
    
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    private func showAlert() {
        
        alertController = UIAlertController(title: "Downloading...",
                                                message: "0%",
                                                preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alertController.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        
        alertController.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alertController.view.frame.width / 2 - size.width / 2,
                                y: self.alertController.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alertController.view.frame.height - 44, width: self.alertController.view.frame.width, height: 2))
            progressView.tintColor = .blue
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alertController.message = String(Int(progress * 100)) + "%"
            }
            
            self.alertController.view.addSubview(activityIndicator)
            self.alertController.view.addSubview(progressView)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        
        dataProvider.fileLocation = { (location) in
            
            self.filePath = location.absoluteString
            self.postNotification()
            self.alertController.dismiss(animated: false, completion: nil)
        }
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
    
    @IBAction func downloadFile(_ sender: Any) {
        dataProvider.startDownload()
        showAlert()
    }
    
    @IBAction func showCommentsWithAlamofire(_ sender: Any) {
        performSegue(withIdentifier: "CommentsWithAlamoFire", sender: self)
        
    }
    
    @IBAction func showImageWithAlamofire(_ sender: Any) {
        performSegue(withIdentifier: "showSegueAlmf", sender: self)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let commentsVC = segue.destination as? CommentsTableViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch segue.identifier {
            case "Comments":
                commentsVC?.fetchData()
            case "CommentsWithAlamoFire":
                commentsVC?.fetchDataWithAlamofire()
            case "showSegue":
                imageVC?.fetchImage()
            case "showSegueAlmf":
                imageVC?.fetchImageWithAlamofire()
            default:
                break
                
        }
    }
}


extension ViewController {
    
    private func registerForNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "file path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
