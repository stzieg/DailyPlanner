//
//  ViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 2/25/19.
//  Copyright © 2019 Sam Ziegler. All rights reserved.
//

import UIKit

class AddAssignmentsViewController: UIViewController {
    
//    @IBOutlet weak var NotesBottomConstraint: NSLayoutConstraint!
    
//    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
//        self.view.endEditing(true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Add assignments screen loaded")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
//    @objc func keyboardWillShow(notification:NSNotification){
//        if let info = notification.userInfo{
//            let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
//            self.view.layoutIfNeeded()
//            UIView.animate(withDuration: 0.25, animations: {
//                self.view.layoutIfNeeded()
//                self.NotesBottomConstraint.constant = rect.height + 20
//            })
//        }
//    }
}
