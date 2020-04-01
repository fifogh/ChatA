//
//  AppDelegate.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/10/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
      ) -> Bool {
      // 1
      guard url.pathExtension == "zip" else { return false }

      // 2
        /*
      Book.importData(from: url)

      // 3
      guard
        let navigationController = window?.rootViewController as? UINavigationController,
        let bookTableViewController = navigationController.viewControllers
          .first as? BooksTableViewController
        else { return true }

      // 4
      bookTableViewController.tableView.reloadData()
 */
      return true
    }

}

