//  AppDelegate.swift
//  OnTheMap Project
//
//  Created by Fatimah Abdulraheem on  28/01/2019.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var uniqueKey = ""
    
    var studentLocations = [SLocation]()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}//end of AppDelegate class

