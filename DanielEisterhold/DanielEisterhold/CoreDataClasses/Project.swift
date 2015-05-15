//
//  Project.swift
//  
//
//  Created by Daniel Eisterhold on 4/20/15.
//
//

import Foundation
import UIKit

protocol ProjectDelegate {
    func imageDownloaded()
}

class Project {

    var name: String
    var date: NSNumber
    var description: String
    var delegate:ProjectDelegate!
    
    private var imageURL: [String] = []
    private var imageCache = [String:UIImage]()
    private var dateFormatter: NSDateFormatter
    
    convenience init(name:String, description:String, url:[String], date:NSNumber) {
        self.init()
        self.name = name
        self.description = description
        self.date = date
        self.imageURL = url

        for(var counter = 0; counter < imageURL.count; counter++) {
            downloadImageWithURL(counter)
        }
    }
    
    init() {
        self.name = "Project"
        self.description = "Project description"
        self.date = NSDate().timeIntervalSince1970
        self.imageCache["placeholder"] = UIImage(named: "projectPlaceholder")!
        self.dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yy"
    }
    
    func downloadImageWithURL(imageNum:Int) {
        println("Downloading image")
        //Start activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: imageURL[imageNum])!, completionHandler: {
            (data:NSData!, response:NSURLResponse!, error:NSError!) in
            //
            self.processImageData(data, imageNum: imageNum, response: response, error: error)
        })
        task.resume()
    }
    
    func processImageData(data:NSData!, imageNum:Int, response:NSURLResponse!, error:NSError!) {
        
        //Stop activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if(error != nil) {
            println("Error: \(error), \(error.userInfo)")
        }
        else {
            println("Image downloaded, processing...")
            let key = imageURL[imageNum]
            imageCache[key] = UIImage(data: data, scale: 3.0)!
            
        }
        self.delegate.imageDownloaded()
    }
    
    func dateString() ->String {
        let timeInterval = NSTimeInterval(date)
        let theDate = NSDate(timeIntervalSince1970: timeInterval)
        return dateFormatter.stringFromDate(theDate)
    }
    
    func imageCount()->Int {
        return imageURL.count
    }
    
    
    func image(index:Int)->UIImage {
        let key = imageURL[index]
        if let image = imageCache[key] {
            return image
        }
        else {
            return imageCache["placeholder"]!
        }
    }
}