//
//  HomeViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var WelcomeLabel: UILabel!
    @IBOutlet var GreetingLabel: UILabel!
    
    var morningGreetings:[String] = ["Welcome","Welcome!","Good Morning!","Good Morning",]
    var afternoonGreetings:[String] = ["Welcome","Welcome!","Good Afternoon!","Good Afternoon"]
    var eveningGreetings:[String] = ["Welcome","Welcome!","Good Evening!","Good Evening"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation bar attributes
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        
        //request permission to send notifications on first use
        NotificationManager.instance.requestAuthorization()
        
        //remove notification badge number when the app is opened
        NotificationManager.instance.removeNotificationBadge()
        
        //Set the date on the homescreen and display a greeting based on the time of day
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d"
        WelcomeLabel.text = formatter.string(from: date)

        let time     = Date()
        let calendar = Calendar.current
        let hour     = calendar.component(.hour, from: time)
        let morning = 3
        let afternoon = 12
        let evening = 17

        if morning <= hour && hour < afternoon {
            GreetingLabel.text = morningGreetings.randomElement()
        }else if afternoon <= hour && hour < evening{
            GreetingLabel.text = afternoonGreetings.randomElement()
        }else{
            GreetingLabel.text = eveningGreetings.randomElement()
        }
    }
}

