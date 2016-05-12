//
//  AppDelegate.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 13/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        customizeAppearance()
        installRootViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

    private func customizeAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        let barTintColor = UIColor(named: .Bar)
        
        navigationBarAppearance.barStyle = .Black // This will make the status bar white by default
        navigationBarAppearance.barTintColor = barTintColor
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }
    
    private func installRootViewController() {
        let navigationController = UINavigationController()
        let wireframe = VolumeListWireframe(navigationController: navigationController)
        let viewController = VolumeListViewController(wireframe: wireframe)
        
        navigationController.pushViewController(viewController, animated: false)
        
        window?.rootViewController = navigationController
    }
}
