//
//  DataLoader.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/20/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataLoader {
    
    private let schoolDataURL = NSURL(string: "http://www.eisterhold.net/WWDC-App/schools.php")
    private var appDelegate:AppDelegate!
    private var managedContext:NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }
    
    func loadData() {
        //Enable network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //Load School and Project Data
        loadSchoolData()
    }
    
    private func loadSchoolData() {
        println("Requesting School Data")
        //Create asyncrhonous URL request
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionDataTask = session.dataTaskWithURL(self.schoolDataURL!, completionHandler:processSchoolData)
        
        //Start the task
        task.resume()
    }
    
    private func processSchoolData(data:NSData!, response:NSURLResponse!, error:NSError!) {
        println("Processing School JSON Data")
        
        //Print message if there exists an error
        if (error != nil) {
            println("API error: \(error), \(error.userInfo)")
        }
        
        //Process the data if we received any
        if(data != nil) {
            //Pass data to JSON library
            var data = JSON(data: data!)
            
            //Get access to School Table
            let schoolEntity =  NSEntityDescription.entityForName("School", inManagedObjectContext: self.managedContext)!
            
            //Save each school data object received
            for(var event = 0; event < data.arrayValue?.count; event++) {
                let school = School(entity: schoolEntity, insertIntoManagedObjectContext: self.managedContext)
                school.setValue(data[event]["Name"].stringValue, forKey: "name")
                school.setValue(data[event]["Level"].stringValue, forKey: "level")
                school.setValue(data[event]["ImageURL"].stringValue, forKey: "imageURL")
                school.setValue(data[event]["Latitude"].doubleValue, forKey: "latitude")
                school.setValue(data[event]["Longitude"].doubleValue, forKey: "longitude")
            }
        }
        
        //Save all the data that was added
        var coreDateError:NSError?
        if(!managedContext.save(&coreDateError)) {
            println("Could not save \(coreDateError), \(coreDateError?.userInfo)")
        }
        
        //Disable network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}