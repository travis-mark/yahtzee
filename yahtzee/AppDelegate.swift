//  yahtzee - AppDelegate.swift
//  Created by Travis Luckenbaugh on 6/16/23.

import UIKit
import SwiftData
import os

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var gameState: GameState!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Diag -- log home folder
        let fileManager = FileManager.default
        log.info("$HOME = \(fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.description ?? "--")")
        
        // Setup db, load game state
        do {
            let container = try ModelContainer(for: GameState.self)
            let descriptor = FetchDescriptor<GameState>()
            let context = container.mainContext
            if let saved = try context.fetch(descriptor).first {
                gameState = saved
            } else {
                let initial = GameState()
                context.insert(initial)
                gameState = initial
            }
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

