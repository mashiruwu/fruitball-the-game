//
//  jugglingfruitsApp.swift
//  jugglingfruits
//
//  Created by Diego Henrick on 19/03/24.
//

import SwiftUI
import UIKit
import FacebookCore
import AppTrackingTransparency
import AdSupport

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}




@main
struct jugglingfruitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            StartViewNew().onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    requestDataPermission()
                }
            }
        }
    }
    
    func requestDataPermission() {

                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        Settings.shared.isAdvertiserTrackingEnabled = true
                        Settings.shared.isAutoLogAppEventsEnabled = true
                        Settings.shared.isAdvertiserIDCollectionEnabled = true
                        
                        print("Authorized")
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        
                        Settings.shared.isAdvertiserTrackingEnabled = false
                        Settings.shared.isAutoLogAppEventsEnabled = false
                        Settings.shared.isAdvertiserIDCollectionEnabled = false
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                })
          
        }
}


