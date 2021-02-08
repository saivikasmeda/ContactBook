//
//  AppDelegate.swift
//  DB_Project
//
//  Created by Student on 3/18/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // This is the first method thats get called from the application is launched.
    // in this method we create a notification object and ask permission to allow notifications.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2)
        let notificationCenter = UNUserNotificationCenter.current()
        let options:UNAuthorizationOptions = [.alert,.sound,.badge]
        notificationCenter.requestAuthorization(options: options){(didallow, error) in
            if !didallow {
            print("User has declined notifications")
            }
        }
        notificationCenter.delegate = self
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
    
    // This method sends the notifcation when there is a update or addition to the database.
     func scheduleNotification(notificationType:String){
            let content = UNMutableNotificationContent()
            content.title = "Update"
            content.body = notificationType
            content.sound = UNNotificationSound.default
            content.badge = 1
            let date = Date(timeIntervalSinceNow: 2)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let identifier = "Local Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (Error) in
                if let error = Error{
                    print("error ",error.localizedDescription)
                }
            }
        }

}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if(response.notification.request.identifier == "Local Notification"){
            print("handling notification")
        }
        completionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}
