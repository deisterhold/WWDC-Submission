//
//  SchoolViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/17/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit
import MapKit

class SchoolViewController: UIViewController {
    
    @IBOutlet var schoolName:UILabel!
    @IBOutlet var schoolImage:UIImageView!
    @IBOutlet var mapView:MKMapView!
    @IBOutlet var schoolDescription:UITextView!
    
    var school:School!
    var loaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if loaded {
            return
        }
        else {
            loaded = true
            println("School View: \(school.name)")
            //Set text and resize label
            schoolName.text = school.name
            schoolName.sizeToFit()
            
            //Set image
            schoolImage.image = school.image()
            
            //Maker the corners rounded
            schoolImage.layer.cornerRadius = 5.0
            schoolImage.layer.masksToBounds = true
            
            //Set border width and color
            schoolImage.layer.borderColor = UIColor.whiteColor().CGColor
            schoolImage.layer.borderWidth = 3.0
            
            //Set map to the schools location
            loadMap(school.location())
            
            //Set description of school
            schoolDescription.text = school.levelDescription()
            schoolDescription.sizeToFit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMap(location:CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.center = location
        region.span.latitudeDelta = 0.05
        region.span.longitudeDelta = 0.05
        mapView.setRegion(region, animated: true)
    }
}
