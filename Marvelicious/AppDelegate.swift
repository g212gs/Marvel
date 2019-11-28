//
//  AppDelegate.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 15/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set Navigation, status bar, UITableViewCell UI
        self.initUI()
        // Remove cache data
        self.setUpImageCacheRemoval()
        // Init Firebase
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        // Stops monitoring network reachability status changes
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //Starts monitoring network reachability status changes
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - Helper methods
extension AppDelegate {
    
    func initUI() {
        // Set Default background color for UITableView cell.. some cases - iPad having default color is white
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        // Set Navigation bar
        self.setNavigationBarUI()
        //Starts monitoring network reachability status changes
        ReachabilityManager.shared.startMonitoring()
    }
    
    func setNavigationBarUI() {
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = false
        }
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.clear
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let attributes = [NSAttributedString.Key.font: Constants.AppRegularFontWithSize(size: 24.0)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        // Set default back button image
        let backImage = UIImage(named: "icon_navBack")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage?.withRenderingMode(.alwaysOriginal)
        
        // Remove back button text : "Back"
        if #available(iOS 11, *) {
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        } else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -60, vertical: -60), for: .default)
        }
        
        // Set Navigation title
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    func setUpImageCacheRemoval() {
        
        // KingFisher Clear cache
        //        // Clear memory cache right away.
        //        ImageCache.default.clearMemoryCache()
        //
        //        // Clear disk cache. This is an async operation.
        //        ImageCache.default.clearDiskCache()
        // 15 MB
        ImageCache.default.memoryStorage.config.totalCostLimit = 15 * 1024 * 1024
        
        // 50 MB // Default value is 0, which means no limit.
        //        ImageCache.default.maxDiskCacheSize = 50 * 1024 * 1024
        
        // 15 days - after that cache will remove
        ImageCache.default.diskStorage.config.sizeLimit = 60 * 60 * 24 * 15
        //        // 30 second // Default value is 15.
        //        ImageDownloader.default.downloadTimeout = 30.0
        // Clean expired or size exceeded disk cache. This is an async operation.
        ImageCache.default.cleanExpiredDiskCache()
    }
}
