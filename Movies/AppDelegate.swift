//
//  AppDelegate.swift
//  Movies
//
//  Created by Maha Govindarajan on 2/6/16.
//  Copyright © 2016 Maha Govindarajan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Set up the first View Controller
        let vc1 :MoviesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MoviesViewController") as! MoviesViewController
       // vc1.view.backgroundColor = UIColor.orangeColor()
        
        
        
        // Set up the second View Controller
        let vc2 :TopRatedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TopRatedViewController") as! TopRatedViewController
       // vc2.view.backgroundColor = UIColor.purpleColor()
        
        let navController1 = UINavigationController(rootViewController: vc1)
        let navController2 = UINavigationController(rootViewController: vc2)
        navController2.navigationItem.title = "Top Rated"
        navController1.tabBarItem.title = "Now Playing"
        navController2.tabBarItem.title = "Top Rated"
        navController1.tabBarItem.image = UIImage(named: "now_playing")
        navController2.tabBarItem.image = UIImage(named: "top_rated")        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navController1, navController2]
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

