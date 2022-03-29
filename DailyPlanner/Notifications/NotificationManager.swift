//
//  NotificationManager.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager{
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error{
                print("ERROR: \(error)")
            }else{
                print("Notifications Enabled")
            }
        }
    }
    
    func scheduleAssignmentNotification(course: String, assignment: String, due: Date, identifier: UUID, completed: Bool){
        let validDate = validateDate(dateToCheck: due)
        if (validDate == true && completed == false){
            //calendar based notification
            let datecomponents = Calendar.current.dateComponents([.year, .month, .day], from: due)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let content = UNMutableNotificationContent()
            
            content.title = course  + " - " + assignment
            content.body = "Due today at " + timeFormatter.string(from: due)
            content.sound = .default
            content.badge = 1
            
            let request = UNNotificationRequest(
                identifier: identifier.uuidString,
                content: content,
                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func scheduleTaskNotification(name: String, due: Date, identifier: UUID, completed: Bool){
        let validDate = validateDate(dateToCheck: due)
        if (validDate == true && completed == false){
            let content = UNMutableNotificationContent()
            
            content.title = "REMINDER!"
            content.body = name
            content.sound = .default
            content.badge = 1
            
            //calendar based notification
            let datecomponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: due)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: identifier.uuidString,
                content: content,
                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func validateDate(dateToCheck: Date) -> Bool{
        if #available(iOS 15, *) {
            if(dateToCheck <= Date.now){
                return false
            }else{
                return true
            }
        } else {
            return true
        }
    }
        
    func cancelNotification(identifier: UUID){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.uuidString])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier.uuidString])
    }
    
    func removeNotificationBadge(){
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
