//
//  ViewController.swift
//  LVHelloToIOS
//
//  Created by Levin Wong on 9/24/14.
//  Copyright (c) 2014 Levin Wong. All rights reserved.
//

import UIKit
import QuartzCore


class SearchResultsViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    NSURLConnectionDelegate,
    NSURLConnectionDataDelegate,
    APIControllerProtocol
{

    @IBOutlet var appsTableView : UITableView?
    
    var albums = [Album]()
    
    var api : APIController?
    
    let kCellIdentifier: String = "SearchResultCell"
    
    var imageCache = [String : UIImage]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //searchItunesFor("JQ Software")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api = APIController(delegate: self)
        api!.searchItunesFor("Angry Birds")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]

        cell.textLabel?.text = album.title
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: NSString = album.price
        cell.detailTextLabel?.text = formattedPrice
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = album.thumbnailImageURL
        
        // image holder
        cell.imageView?.image = UIImage(named: "Blank52")
        
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }

    

}


