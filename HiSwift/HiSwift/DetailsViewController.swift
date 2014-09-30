//
//  DetailsViewController.swift
//  LVHelloToIOS
//
//  Created by Levin Wong on 9/28/14.
//  Copyright (c) 2014 Levin Wong. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    APIControllerProtocol
{
    
    var album: Album?
    var tracks = [Track]()
    lazy var api : APIController = APIController(delegate: self)
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var curTrack: Track?
    var lastTrackCell: TrackCell?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load in tracks
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
        
        var albumTitle = self.album?.title
        navigationItem.title = albumTitle;
        
        titleLabel.text = albumTitle
        //albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)))
        albumCover.image = UIImage(named: "Blank52")
        
        // Download an NSData representation of the image at the URL
        var imgURL: NSURL = NSURL(string: self.album!.largeImageURL)
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        var image: UIImage?
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                image = UIImage(data: data)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.albumCover.image = image
                })
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
        mediaPlayer.stop()
        
        if  lastTrackCell != nil {
            lastTrackCell?.playIcon.text =  "▶️";
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            if curTrack != nil && curTrack!.id == track.id {
                cell.playIcon.text = "▶️";
                curTrack = nil;
                return
            }
            mediaPlayer.contentURL = NSURL(string: track.previewUrl)
            mediaPlayer.play()
            cell.playIcon.text = "◼️"
            curTrack = track
            lastTrackCell = cell
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(resultsArr)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    

    
}
