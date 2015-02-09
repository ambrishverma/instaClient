//
//  PhotosViewController.swift
//  InstaClient
//
//  Created by Anoop tomar on 2/4/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelWarning: UILabel!
    
    var mediaArray : NSArray?
    var mediaImages : NSDictionary?
    var imageArray : NSMutableArray = []
    
    @IBOutlet weak var PhotoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 300;

        // Do any additional setup after loading the view.
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=2aceb02ffa364b618b48f2c58f1b6562");
        let request = NSURLRequest (URL: url!)
  
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            
            var dataArray = dictionary["data"] as NSArray
            
            for i in 0..<dataArray.count{
                var tempImage = ((dataArray[i]) as NSDictionary)["images"] as NSDictionary
                self.imageArray.addObject(((tempImage["standard_resolution"]) as NSDictionary)["url"] as NSString);
            }
            
            self.tableView.reloadData();
        });
    }
    
    class func downloadImage(url: NSURL, handler: ((image: UIImage, NSError!)->Void)){
        // NSLog(url.absoluteString!)
        var imageRequest: NSURLRequest = NSURLRequest(URL: url);
        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) in
            
            let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
            
            var error : NSError! = error;
            if(statusCode == 200 ){
                handler(image: UIImage(data: data)!, error)
            }else{
                NSLog("\(statusCode)");
            }
        });
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell (style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Row\(indexPath.row)"
        
        var imageView = UIImageView(frame: CGRect(x: 100, y: 5, width: 200, height: 290))
        imageView.backgroundColor = UIColor.redColor()
        PhotosViewController.downloadImage(NSURL(string: imageArray[indexPath.row] as NSString)!,{
            image, error in imageView.image = image
        });

        cell.addSubview(imageView)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
