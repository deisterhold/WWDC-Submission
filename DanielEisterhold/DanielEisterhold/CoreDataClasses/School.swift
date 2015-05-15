//
//  School.swift
//  
//
//  Created by Daniel Eisterhold on 4/20/15.
//
//

import Foundation
import CoreData
import CoreLocation
import UIKit

class School: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var level: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var imageURL: String
    
    var schoolImage:UIImage!
    
    //Override intialize to that the date formatter is initialized
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
    }
    
    func image() -> UIImage {
        if let url = NSURL(string: imageURL) {
            
            if let data = NSData(contentsOfURL: url) {
                self.schoolImage = UIImage(data: data)!
            }
            else {
                self.schoolImage = UIImage(named: "schoolPlaceholder")!
            }
        }
        return self.schoolImage
    }
    
    func location() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
    }
    
    func levelDescription() -> String {
        switch(level) {
        case "ELEMENTARY":
            return "Level: Elementary School"
        case "MIDDLE":
            return "Level: Middle School"
        case "HIGH":
            return "Level: High School"
        case "COLLEGE":
            return "Level: College"
        default:
            return "Level: Unknown"
        }
    }
}