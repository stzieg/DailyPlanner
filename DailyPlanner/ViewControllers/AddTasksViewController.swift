//
//  ViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 2/25/19.
//  Copyright © 2019 Sam Ziegler. All rights reserved.
//

import UIKit

class AddTasksViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var TaskNameField: UITextField!
    @IBOutlet weak var TaskNotesField: UITextView!
    
    @IBAction func closeTaskName(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Add tasks screen loaded")
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddTasksViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTasksViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done , target: self, action: #selector(self.doneClicked))
        
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.cyan
        toolbar.setItems([flexSpace,doneButton], animated: true)
        
        TaskNameField.inputAccessoryView = toolbar
        TaskNotesField.inputAccessoryView = toolbar
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        var shouldMoveViewUp = false
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        if (self.TaskNotesField .isFirstResponder){
            shouldMoveViewUp = true
        }
                
        if(shouldMoveViewUp == true){
        // move the root view up by the distance of keyboard height
            self.view.bounds.origin.y = 0 + keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        // move back the root view origin to zero
        self.view.bounds.origin.y = 0
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
}
