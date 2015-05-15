//
//  ProjectDetailViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/13/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var imageView:UIImageView!
    
    @IBOutlet var projectName:UILabel!
    @IBOutlet var projectDate:UILabel!
    @IBOutlet var projectDescription:UITextView!
    
    var project:Project!
    var pageViews:[UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calculate the size of the view for the background image
        let width = UIScreen.mainScreen().bounds.width
        let height = width*(9.0/16)
        
        //Prevent text view from being resized automatically
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Set text to display below the image
        projectDescription.frame = CGRect(x: 16, y: height, width: width-32, height: 100)
        
        //Set text of the labels and text view
        projectName.text = project.name
        projectDate.text = project.dateString()
        projectDescription.text = project.description
        
        //Adjust labels to text inside of them
        projectName.sizeToFit()
        projectDate.sizeToFit()
        projectDescription.sizeToFit()
        
        //Create effects for both labels
        let nameEffect = UIBlurEffect(style: .Dark)
        let dateEffect = UIBlurEffect(style: .Dark)
        
        //Create views for the effects
        let nameEffectView = UIVisualEffectView(effect: nameEffect)
        let dateEffectView = UIVisualEffectView(effect: dateEffect)
        
        //Set the views for the labels
        nameEffectView.frame = projectName.frame
        dateEffectView.frame = projectDate.frame
        
        //Make the corners rounded
        nameEffectView.layer.cornerRadius = 3.0
        dateEffectView.layer.cornerRadius = 3.0
        
        //Mask the views to the rounded corners
        nameEffectView.layer.masksToBounds = true
        dateEffectView.layer.masksToBounds = true
        
        //Add the views to the screen
        self.view.addSubview(nameEffectView)
        self.view.addSubview(dateEffectView)
        
        //Bring the labels to the front of the screen
        self.view.bringSubviewToFront(projectName)
        self.view.bringSubviewToFront(projectDate)
        
        //Set the image to the dimensions above and at the top left corner of the screen
        scrollView.frame = CGRectMake(0, 0, width, height)
        
        //Make array big enough for each image
        for img in 0..<project.imageCount() {
            pageViews.append(nil)
        }
        
        //Calculate size of scroll view (image width * number of images)
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(project.imageCount()), height: pagesScrollViewSize.height)
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= project.imageCount() {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            
            let width = UIScreen.mainScreen().bounds.width
            let height = width*(9.0/16)
            var frame = CGRectMake(width  * CGFloat(page), 0, width, height)
            
            
            let newPageView = UIImageView(frame: frame)
            newPageView.contentMode = .ScaleAspectFill
            newPageView.image = project.image(page)
            scrollView.addSubview(newPageView)
            
            //Add view to array
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= project.imageCount() {
            //Of view doesn't exit do nothing
            return
        }
        
        //If the view is in the array remove it then
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        //Find out what view is being shown
        let pageWidth = UIScreen.mainScreen().bounds.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        //Update current page
//        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < project.imageCount(); ++index {
            purgePage(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
