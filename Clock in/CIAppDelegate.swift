//
//  AppDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class CIAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var shouldResetRealm = false
    var shouldResetNSUserDefaults = false
    var shouldGenerateTestData = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if(shouldResetRealm) { purgeRealm() }
        if(shouldResetNSUserDefaults) { purgeNSUserDefaults() }
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil))
        initNSUserDefaultsIfNeeded()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = .whiteColor()
        self.window!.rootViewController = CIHomeViewController()
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    func purgeRealm() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.URLByAppendingPathExtension("lock"),
            realmURL.URLByAppendingPathExtension("log_a"),
            realmURL.URLByAppendingPathExtension("log_b"),
            realmURL.URLByAppendingPathExtension("note")
        ]
        let manager = NSFileManager.defaultManager()
        for URL in realmURLs {
            do {
                try manager.removeItemAtURL(URL)
            } catch {
                // handle error
            }
        }
    }
    
    func purgeNSUserDefaults() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
    }
    
    func notificationsEnabledInSettings() -> Bool {
        let grantedSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        return grantedSettings!.types.contains(.Alert)
    }
    
    func initNSUserDefaultsIfNeeded() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasWrittenDefaults = defaults.boolForKey(.CIHasWrittenDefaults)
        if hasWrittenDefaults { return }
        defaults.setBool(notificationsEnabledInSettings(), forKey: .CIDefaultNotificationsOn)
        defaults.setObject(CIConstants.notificationIntervals, forKey: .CIDefaultNotificationIntervals)
        defaults.setBool(false, forKey: .CIDefaultAlertForcedClockOut)
        defaults.setBool(true, forKey:  .CIHasWrittenDefaults)
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
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let root = self.window!.rootViewController as! CIHomeViewController
        let managers = root.itemManagers
        let defaults = NSUserDefaults.standardUserDefaults()
        for manager in managers {
            if(manager.clockedIn) {
                manager.clockOut()
                defaults.setBool(true, forKey: .CIDefaultAlertForcedClockOut)
            }
        }
    }
}

