//
//  AppDelegate.swift
//  Example iOS
//
//  Created by panghu on 05/17/20.
//  Copyright © 2020 panghu. All rights reserved.
//

import UIKit
import CXFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
