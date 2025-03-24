//
//  PrototypeApp.swift
//  Prototype
//
//  Created by 최낙주 on 3/16/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct PrototypeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("user_id") private var userId: String = ""
    
    var body: some Scene {
        WindowGroup {
            if !userId.isEmpty {
                MainView()
                    .environmentObject(ViewModel())
                    .onOpenURL { url in
                        print("Received URL: \(url)")
                        Auth.auth().canHandle(url)
                    }
                
            } else {
                PhoneAuthView()
                    .onOpenURL { url in
                        Auth.auth().canHandle(url)
                    }
            }
        }
    }
}
