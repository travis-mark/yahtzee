//  yahtzee - AppDelegate.swift
//  Created by Travis Luckenbaugh on 6/16/23.

import UIKit
import SwiftData

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var container: ModelContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Diag -- log home folder
        let fileManager = FileManager.default
        log.info("$HOME = \(fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.description ?? "--")")
        
        // Setup db
        do {
            container = try ModelContainer(for: [Game.self, HighScore.self])
        } catch {
            log.error("Fatal error in db init :: \(error.localizedDescription)")
            abort()
        }
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
}

