//
//  Boss_ClinicApp.swift
//  Boss Clinic
//
//  Created by Onqanet on 24/06/26.
//

import SwiftUI
import FirebaseCore






@main
struct Boss_ClinicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            FlipCardsView()
        }
    }
}
