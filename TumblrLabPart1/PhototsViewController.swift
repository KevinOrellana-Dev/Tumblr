//
//  PhototsViewController.swift
//  TumblrLabPart1
//
//  Created by admin on 3/19/20.
//  Copyright © 2020 kevin.orellana06@gmail.com. All rights reserved.
//

import UIKit
import AlamofireImage // this library will help to process an image from a specified URL

class PhototsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var photosTableView: UITableView!
    
    
    var posts: [[String: Any]] = [] // Inititializing it to an empty array;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosTableView.delegate = self
        photosTableView.dataSource = self
        
        
        //Getting information from API
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data,
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              print(dataDictionary)

              //Get the posts and store in posts property
            let responseDictionary = dataDictionary["response"] as! [String: Any]
            self.posts = responseDictionary ["posts"] as! [[String: Any]]
            
              // TODO: Reload the table view
            self.photosTableView.reloadData()
          }
        }
        task.resume()
        
        
        

   
    }
    
    
    //This method sets the number of rows for the "photosTableView"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    //This method returns a custom cell for each row of the "photosTableView". Essentially this method is called each time a cell is made or referenced.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = photosTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let post = posts [indexPath.row]
        
        if let photos = post["photos"] as? [[String: Any]]
        {
            //disecting information from API
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString) //URl that contains the image of the corresponding post
            cell.photoImageView.af_setImage(withURL: url!)
        }
        
   
        return cell
        
    }
    


}
