//
//  AppDelegate.swift
//  PollfishMaxAdapterExampleSwift
//
//  Created by Fotis Mitropoulos on 16/2/22.
//

import UIKit
import AppLovinSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ALSdk.shared()!.mediationProvider = "max"
        
        ALSdk.shared()!.initializeSdk(completionHandler: nil)
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

