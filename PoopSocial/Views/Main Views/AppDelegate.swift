//
//  AppDelegate.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/27/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
  
    func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
      launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      
        FirebaseApp.configure()
        
        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2
        registerForPushNotifications()
        // 3 - Sets AppDelegate as the delegate for Messaging
        Messaging.messaging().delegate = self
        
        updateFirestorePushTokenIfNeeded()
      
        return true
      
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("FOUND ERROR: \(error.localizedDescription)")
        }
    
    func updateFirestorePushTokenIfNeeded() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
        if let token = Messaging.messaging().fcmToken {
            // sync user and friendship collection documents when fcmToken is updated
            
            // update local info
            UserData.shared.fcmToken = token
            
            let userRef = FirebaseManager.shared.firestore.collection("users").document(uid)
            userRef.setData(["FCMToken": token], merge: true)
        }
    }
    
    // register for notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    // get current user permissions
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // gets called when notif is pushed in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        print("RECIEVED NOTIF IN FOREGROUND")
        process(notification)
        completionHandler([[.banner, .sound]])
      
    }

    // gets called when user taps on notification
    func userNotificationCenter( _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("RECIEVED")
        process(response.notification)
        completionHandler()
      
    }
    
    // gets called when app is in foreground and notification arrives
  /*  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(UNNotificationPresentationOptionsNone)
    }*/
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
      Messaging.messaging().apnsToken = deviceToken
        
    }
    

    
    private func process(_ notification: UNNotification) {
      // 1
      //let userInfo = notification.request.content.userInfo
      // 2
    }
    
}

extension AppDelegate: MessagingDelegate {
  func messaging( _ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
    let tokenDict = ["token": fcmToken ?? ""]
      
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
      
      updateFirestorePushTokenIfNeeded()
  }
}
