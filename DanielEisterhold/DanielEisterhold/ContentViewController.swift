//
//  EducationDetailViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/13/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var theView:UIView!
    
    var school:School!
    
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Content View")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "schoolViewSegue") {
            var containerView = segue.destinationViewController as! SchoolViewController
            containerView.school = self.school
        }
    }
}