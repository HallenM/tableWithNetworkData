//
//  AppDelegate.swift
//  app03.2.0
//
//  Created by developer on 15.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create a basic UIWindow
        window = UIWindow(frame: UIScreen.main.bounds)
                
        // Create the maiControllersn navigation controller to be used for app
        let nController = UINavigationController()
        
        // Activate basic UIWindow
        window?.rootViewController = nController
        window?.makeKeyAndVisible()
        
        // Send that into our coordinator so that it can display view controllers
        coordinator = MainCoordinator(navigationController: nController)
        
        // Tell the coordinator to take over control
        coordinator?.start()
        
        return true
    }
}

