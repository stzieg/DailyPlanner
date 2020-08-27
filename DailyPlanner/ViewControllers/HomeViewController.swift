//
//  HomeViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 2/25/19.
//  Copyright © 2019 Sam Ziegler. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var WelcomeLabel: UILabel!
    @IBOutlet var GreetingLabel: UILabel!
    
    var morningGreetings:[String] = ["Welcome","Welcome!","Good morning!","Good morning",]
    var afternoonGreetings:[String] = ["Welcome","Welcome!","Good afternoon!","Good afternoon"]
    var eveningGreetings:[String] = ["Welcome","Welcome!","Good evening!","Good evening"]
    var nightGreetings:[String] = ["Welcome","Welcome!","Good night!","Good night"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Home screen loaded")
        self.navigationController?.navigationBar.shadowImage=UIImage()
        
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
        let afternoon=12
        let evening=16
        let night=22

        print("Hour: \(hour)")
        if morning <= hour && hour < afternoon {
            //Morning Greeting
            GreetingLabel.text = morningGreetings.randomElement()
        }else if afternoon <= hour && hour < evening{
            //Afternoon Greeting
            GreetingLabel.text = afternoonGreetings.randomElement()
        }else if evening <= hour && hour < night{
            //Evening Greeting
            GreetingLabel.text = eveningGreetings.randomElement()
        }else if night <= hour && hour < morning{
            //Night Greeting
            GreetingLabel.text = nightGreetings.randomElement()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
}

