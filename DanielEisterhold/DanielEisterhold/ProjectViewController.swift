//
//  ProjectViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/13/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit
import CoreData

class ProjectViewController:UITableViewController, ProjectDelegate {
    
    private let projectDataURL = NSURL(string: "http://www.eisterhold.net/WWDC-App/projects.php")
    private var projectsCache:NSData!
    var projects:[Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Loading Project VC")
        
        //Set navigation bar title color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:flameOrange]
        
        //Start loading info from the database
        downloadProjectData()
        
        //Enable pull to refresh on the table view
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("downloadProjectData"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let theCell = tableView.dequeueReusableCellWithIdentifier("projectCell") as? UITableViewCell
        
        let project = projects[indexPath.row]
        
        let textLabel = theCell?.contentView.viewWithTag(3) as? UILabel
        let detailTextLabel = theCell?.contentView.viewWithTag(1) as? UILabel
        let imageView = theCell?.contentView.viewWithTag(2) as? UIImageView
        
        textLabel?.text = project.name
        detailTextLabel?.text = project.dateString()
        imageView?.contentMode = .ScaleAspectFit
        imageView?.clipsToBounds = true
        imageView?.image = project.image(0)
        
//        println(imageView)
        return theCell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get destination view controller
        let projectDetailViewController = segue.destinationViewController as? ProjectDetailViewController
        
        //Get index of the table cell that was tapped
        let index = self.tableView.indexPathForSelectedRow()?.row
        
        //Send the project to the destination view controller
        projectDetailViewController?.project = projects[index!]
    }
    
    func downloadProjectData() {
        println("Requesting Project Data")
        //Create asyncrhonous URL request
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionDataTask = session.dataTaskWithURL(self.projectDataURL!, completionHandler:processProjectData)
        
        //Start the task
        task.resume()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    private func processProjectData(data:NSData!, response:NSURLResponse!, error:NSError!) {
        println("Processing Project JSON Data")
        
        //If the data hasn't changed don't do anything
        if projectsCache != nil && projectsCache.isEqualToData(data) {
            println("Data is the same.")
            //Disable network indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            //Stop showing refresh status indicator
            if (self.refreshControl!.refreshing) {
                self.refreshControl?.endRefreshing()
            }
            return
        }
        else {
            projectsCache = data
        }
        //After the network request has finished disable the indicator
//        println("Disabling network indicator")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //Stop showing refresh status indicator
        if (self.refreshControl!.refreshing) {
            self.refreshControl?.endRefreshing()
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        //Print message if there exists an error
        if (error != nil) {
            println("API error: \(error), \(error.userInfo)")
        }
        
        //Process the data if we received any
        if(data != nil) {
            //Pass data to JSON library
            var data = JSON(data: data!)
            
            //Reset the array so we are continually adding new stuff
            projects = []
            
            //Save each project data object received
            for(var event = 0; event < data.arrayValue?.count; event++) {
                let date = dateFormatter.dateFromString(data[event]["Date"].stringValue!)!
                let urlArray:[String] = split(data[event]["ImageURL"].stringValue!) {$0 == " "}
                
                self.projects.append(Project(name: data[event]["Name"].stringValue!, description: data[event]["Description"].stringValue!, url: urlArray, date: date.timeIntervalSince1970))
                self.projects[self.projects.count-1].delegate = self
            }
            
            //Sort the projects by date
            projects.sort(sortProjectsByDate)
            
            //Refresh the Table with the newly loaded data
            dispatch_async(dispatch_get_main_queue(), {
                //println("Reloading table")
                self.tableView.reloadData()
            })
        }
    }
    
    func imageDownloaded() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}

func sortProjectsByDate(first:Project, second:Project)->Bool {
    if(first.date > second.date) {
        return true
    }
    else {
        return false
    }
}
