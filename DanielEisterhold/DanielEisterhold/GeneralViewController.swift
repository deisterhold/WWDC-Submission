//
//  GeneralViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/13/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    
    let url = NSURL(string: "http://www.eisterhold.net/WWDC-App/About.php")!
    
    @IBOutlet var portraitView:UIImageView!
    @IBOutlet var headerBackground:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var shortDescription:UILabel!

    @IBOutlet var longDescription:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Loading General VC")
        //Update the status bar color
        self.setNeedsStatusBarAppearanceUpdate()
        
        println("Requesting Project Data")
        //Create asyncrhonous URL request
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionDataTask = session.dataTaskWithURL(url) {
            (data:NSData!, response:NSURLResponse!, error:NSError!) in
            
            println("Processing JSON Data")
            
            //After the network request has finished disable the indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            //Print message if there exists an error
            if (error != nil) {
                println("API error: \(error), \(error.userInfo)")
            }
            
            //Process the data if we received any
            if(data != nil) {
                //Pass data to JSON library
                var data = JSON(data: data!)
                
                //Refresh the Table with the newly loaded data
                dispatch_async(dispatch_get_main_queue(), {
                    self.nameLabel.text = data[0]["Name"].stringValue
                    self.shortDescription.text = data[0]["About"].stringValue
                    self.longDescription.text = data[0]["Description"].stringValue
                })
                
            }
        }
        
        //Start the task
        task.resume()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let width = UIScreen.mainScreen().bounds.width
        let height = width/2.0
        headerBackground.frame = CGRectMake(0, 0, width, height)
        headerBackground.contentMode = UIViewContentMode.ScaleAspectFill
        headerBackground.image = UIImage(named: "Grass")
        
        portraitView.frame = CGRectMake(16, 16, 100, 100)
        portraitView.contentMode = UIViewContentMode.ScaleAspectFill
        portraitView.image = UIImage(named: "Portrait")

        portraitView.layer.borderWidth = 3.0
        portraitView.layer.borderColor = UIColor.whiteColor().CGColor
        portraitView.layer.cornerRadius = CGFloat(30)
        portraitView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
