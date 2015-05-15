//
//  EducationViewController.swift
//  DanielEisterhold
//
//  Created by Daniel Eisterhold on 4/13/15.
//  Copyright (c) 2015 Daniel Eisterhold. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var schools:[School] = []
    var currentIndex: Int = 0
    
    var appDelegate:AppDelegate!
    var managedContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Container View")
        self.view.backgroundColor = UIColor.blackColor()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        loadSchools()
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        if let startingViewController: ContentViewController = viewControllerAtIndex(0) {
            let viewControllers: NSArray = [startingViewController]
            pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
            pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
            
            addChildViewController(pageViewController!)
            view.addSubview(pageViewController!.view)
            pageViewController!.didMoveToParentViewController(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex!
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex!
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.schools.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController?
    {
        if self.schools.count == 0 || index >= self.schools.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("contentViewController") as! ContentViewController
        pageContentViewController.school = schools[index]
        pageContentViewController.view.backgroundColor = UIColor.clearColor()
        println("School: \(schools[index].name)")
        pageContentViewController.pageIndex = index
        pageContentViewController.theView.layer.cornerRadius = CGFloat(30)
        pageContentViewController.theView.clipsToBounds = true
        currentIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.schools.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return currentIndex
    }
    
    func loadSchools() {//Show a loading indicator in the center of the screen
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //Load projects from CoreData
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        managedContext = appDelegate.managedObjectContext;
        let fetchRequest = NSFetchRequest(entityName: "School")
        let sortMethod = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortMethod];
        
        var error:NSError?
        let fetchedResults = managedContext?.executeFetchRequest(fetchRequest, error: &error) as? [School]
        
        if (error != nil) {
            println("Error fetching data: \(error), \(error?.userInfo)")
        }
        else {
            schools = fetchedResults!
        }
        
        //Stop showing the activity indicator and remove from view
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}