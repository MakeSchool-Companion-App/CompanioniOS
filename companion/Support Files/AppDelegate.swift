//
//  AppDelegate.swift
//  companion
//
//  Created by Yves Songolo on 9/6/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import iBeaconManager
import CoreLocation

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconManager: BeaconManager!
    var registeredBeacon: Beacon?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Anything that accesses NavigationBar will contain these default parameters
        UINavigationBar.appearance().tintColor = .white
        // This will set the nav bar color to a light red color
        UINavigationBar.appearance().barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        // This will disable the navbar's translucency
        UINavigationBar.appearance().isTranslucent = false
        // When the tablview is scrolled, this will resize the title text
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        // This will make nav bar's font bold
        UINavigationBar.appearance().prefersLargeTitles = true
        // Set the color of the font to white
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        
        /// monitoring for make school
        
        GeoFenceServices.startMonitoringMakeschool()
        
        
        
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let scanBeaconController = ScanBeaconController()
        window?.rootViewController = scanBeaconController
        
        
        registeredBeacon = Beacon(uuid: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 44941, minor: 4437, identifier: "God help me")
        if let registeredBeacon = registeredBeacon {
            beaconManager = BeaconManager(beacon: registeredBeacon)
        }
      
        
        let email = "yves.songolo@students.makeschool.com"
        let email2 = "yves.songolo@gmail.com"
        let password = "songolo93"
        let loc = AppDelegate.shared.beaconManager.beaconRegion.proximityUUID.uuidString
        let date = Date().toString()
       let att = Attendance.init(date, event: .onEntry, beaconId: "0000")
        
        UserServices.login(email: email2, password: password) { (user) in
            if let user = user as? User{
                print (user.token!)
                AttendanceServices.create(att, completion: { (attendance) in
                    print(attendance)
                    
                    AttendanceServices.show(completion: { (attendace) in
                        print(attendance)
                    })
                })
                
            }
        }
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
    }

