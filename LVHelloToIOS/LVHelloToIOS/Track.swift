//
//  Track.swift
//  LVHelloToIOS
//
//  Created by Levin Wong on 9/28/14.
//  Copyright (c) 2014 Levin Wong. All rights reserved.
//

import Foundation

class Track {
    
    var title: String
    var price: String
    var previewUrl: String
    var id: String
    
    init(id:String, title: String, price: String, previewUrl: String) {
        self.id = id
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    class func tracksWithJSON(allResults: NSArray) -> [Track] {
        
        var tracks = [Track]()
        
        if allResults.count>0 {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        
                        var trackPrice = NSString(format: "%.2f",trackInfo["trackPrice"] as? Double ?? 0.00)
                        var trackTitle = trackInfo["trackName"] as? String
                        var trackPreviewUrl = trackInfo["previewUrl"] as? String
                        var trackId = String(trackInfo["trackId"] as? Int ?? 0)

                        if(trackTitle == nil) {
                            trackTitle = "Unknown"
                        }
                        if(trackPreviewUrl == nil) {
                            trackPreviewUrl = ""
                        }
                        
                        var track = Track(id: trackId, title: trackTitle!, price: trackPrice, previewUrl: trackPreviewUrl!)
                        tracks.append(track)
                        
                    }
                }
            }
        }
        return tracks
    }
    
}
