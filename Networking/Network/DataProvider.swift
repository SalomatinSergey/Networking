//
//  DataProvider.swift
//  Networking
//
//  Created by Sergey on 20.05.2022.
//

import UIKit

class DataProvider: NSObject {
    
    private let url = "https://speed.hetzner.de/100MB.bin"
    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) ->())?
    var onProgress: ((Double) -> ())?
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "www.apple.com")
//        config.isDiscretionary = true
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        
        if let url = URL(string: url) {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        } else {
            print("Error download")
        }
            
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
                  let completionHandler = appdelegate.bgSessionCompletionHandler
            else { return }
            
            appdelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        
//        print("Download progress \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
     
}
