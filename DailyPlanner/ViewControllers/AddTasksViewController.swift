//
//  AddTasksViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class AddTasksViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var TaskNameField: UITextField!
    @IBOutlet weak var TaskNotesField: UITextView!
    @IBOutlet weak var TaskReminderDate: UIDatePicker!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var AddTaskButton: UIButton!
    
    var isEdit = false
    var editTaskName = ""
    var editTaskNotes = ""
    var editReminder = Date.distantPast
    var editCreatedDate = Date.distantPast
    var editCompleted = false
    
    var uniqueIdentifier = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set all fields if the assignment is being edited
        if isEdit == true{
            TaskNameField.text = editTaskName
            TaskNotesField.text = editTaskNotes
            TaskReminderDate.date = editReminder
            AddTaskButton.setTitle("Edit Task", for: .normal)
            self.title = "Edit"
            
            if #available(iOS 15, *) {
                if TaskReminderDate.date <= Date.now{
                    reminderSwitch.isOn = false
                    TaskReminderDate.isHidden = true
                }else{
                    let calendar = Calendar.current
                    let date = calendar.date(byAdding: .minute, value: 5, to: editCreatedDate)
                    
                    TaskReminderDate.minimumDate = date
                    reminderSwitch.isOn = true
                    TaskReminderDate.isHidden = false
                }
            }
        }else{
            reminderSwitch.isOn = false
            TaskReminderDate.isHidden = true
        }
        
        //Initial setup
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
        TaskNameField.autocapitalizationType = .sentences
        if #available(iOS 13.4, *) {
            TaskReminderDate.preferredDatePickerStyle = .automatic
        }
        TaskReminderDate.tintColor = .white
    }
    
    //Displays/hides the date picker depending on toggle status of the reminder switch
    @IBAction func reminderSwitchValue(sender: UISwitch){
        if (reminderSwitch.isOn){
            TaskReminderDate.minimumDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
            TaskReminderDate.isHidden = false;
        }else{
            TaskReminderDate.isHidden = true;
        }
    }
        
    //Add or edit a task and schedule a notification if the reminder switch is on
    @IBAction func addTask(_ sender: UIButton) {
        if(!reminderSwitch.isOn){
            TaskReminderDate.minimumDate = Date.distantPast
            TaskReminderDate.setDate(Date.distantPast, animated: true)
        }
        
        let taskItem = TaskItem(
            name: TaskNameField.text!,
            reminder: TaskReminderDate.date,
            notes: TaskNotesField.text,
            completed: editCompleted,
            createdAt: Date(),
            identifier: uniqueIdentifier,
            type: "task")
        
        if (taskItem.name == ""){
            TaskNameField.layer.borderColor = UIColor.red.cgColor
            TaskNameField.layer.borderWidth = 2.0
        }else{
            TaskNameField.layer.borderColor = UIColor.clear.cgColor
            if (isEdit == true){
                taskItem.editTask()
            }else{
                taskItem.saveTask()
            }
            NotificationManager.instance.scheduleTaskNotification(
                name: TaskNameField.text!,
                due: TaskReminderDate.date,
                identifier: uniqueIdentifier,
                completed: editCompleted)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // move the root view up by the distance of keyboard height
    @objc func keyboardWillShow(notification: NSNotification){
        var shouldMoveViewUp = false
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        if (self.TaskNotesField .isFirstResponder){
            shouldMoveViewUp = true
        }
        if(shouldMoveViewUp == true){
            self.view.bounds.origin.y = 0 + keyboardSize.height
        }
    }
    
    // move back the root view origin to zero
    @objc func keyboardWillHide(notification: NSNotification){
        self.view.bounds.origin.y = 0
    }
    
    //Keyboard Resignation functions
    @objc func doneClicked(){
        view.endEditing(true)
    }
    @IBAction func closeTaskName(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
