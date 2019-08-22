//
//  AppDelegate.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
import AppCenterAuth
import AppCenterData
import AppCenterPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MSPushDelegate {
                            
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MSPush.setDelegate(self);
        MSAppCenter.start("06cf3a29-2613-4e12-a5ad-96d5d2d79f3d", withServices:[
            MSCrashes.self, MSAnalytics.self, MSAuth.self, MSData.self, MSPush.self
            ]);
        
        // Force a login every time for demo purposes
        MSAuth.signOut();
        
        MSAuth.signIn { userInformation, error in
            
            if error == nil {
                // Sign-in succeeded.
                _ = userInformation!.accountId;
                _ = userInformation!.idToken;
                _ = userInformation!.accessToken;
            } else {
                // Do something with sign failure.
            }
            
        }
        
        return true
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
    }

    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        let title: String = pushNotification.title ?? ""
        var message: String = pushNotification.message ?? ""
        var customData: String = ""
        for item in pushNotification.customData {
            customData =  ((customData.isEmpty) ? "" : "\(customData), ") + "\(item.key): \(item.value)"
        }
        if (UIApplication.shared.applicationState == .background) {
            NSLog("Notification received in background, title: \"\(title)\", message: \"\(message)\", custom data: \"\(customData)\"");
        } else {
            message =  message + ((customData.isEmpty) ? "" : "\n\(customData)")
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            // Show the alert controller.
            self.window?.rootViewController?.present(alertController, animated: true)
        }
    }

}

