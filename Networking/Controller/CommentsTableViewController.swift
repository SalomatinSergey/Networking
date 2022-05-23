//
//  CommentsTableViewController.swift
//  Networking
//
//  Created by Sergey on 19.05.2022.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    private let jsonUrlString = "https://jsonplaceholder.typicode.com/posts/1/comments"

    private var comments = [Comments]()
    private var commentName: String?
    private var commentUrl: String?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        fetchData()
//
//    }
//    
    func fetchData() {
        
        NetworkManager.fetchData(url: jsonUrlString) { [weak self] comments in
            self?.comments = comments
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    
    func fetchDataWithAlamofire() {
        
        AlamofireNetworkRequest.sendRequest(url: jsonUrlString) {[weak self] comments in
            self?.comments = comments
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let comments = comments[indexPath.row]
        
        cell.nameLabel.text = comments.name
        cell.textView.text = comments.body
        cell.textView.isEditable = false
        
        if let email = comments.email {
            cell.emailLabel.text = email
        }
 
        DispatchQueue.global().async {
            guard let image = comments.imageUrl else {return}
            guard let imageUrl = URL(string: image) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        guard let customCell = cell else { return UITableViewCell() }

        configureCell(cell: customCell, for: indexPath)

        return customCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comments = comments[indexPath.row]
        
        commentUrl = comments.imageUrl
        commentName = comments.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }



    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let descriptionViewController = segue.destination as! DescriptionViewController
        descriptionViewController.selectedCourse = commentName
        
        if let url = commentUrl {
            descriptionViewController.commentUrl = url
        }
    }

}



