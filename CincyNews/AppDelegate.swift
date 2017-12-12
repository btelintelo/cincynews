//
//  AppDelegate.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import RealmSwift
import BuddyBuildSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()
        return true
    }


    var window: UIWindow?
    
    public class func realmConfig() -> Realm.Configuration{
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        NotificationCenter.default.post(name: Notification.Name(rawValue: "foreground"), object: nil, userInfo: nil)
        
        //Clear old data
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "readList")
        UserDefaults.standard.synchronize()
        
        let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
        if setting != nil{
            return
        }
        let settings = Settings()
        settings.afterStoryRead = "gray"
        
        try! realm.write {
            let rs = RealmString()
            rs.value = "fox19"
            let rs2 = RealmString()
            rs2.value = "wlwt"
            let rs3 = RealmString()
            rs3.value = "wcpo-sports"
            settings.feedKeys.append(rs)
            settings.feedKeys.append(rs2)
            settings.feedKeys.append(rs3)
            realm.add(settings)
        }
        
        
        BuddyBuildSDK.setup()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    
    }


    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.interactivespaces.cinbox.CincinnatiInbox" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

}

