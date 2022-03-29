//
//  AddAssignmentsViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class AddAssignmentsViewController: UIViewController {
    
    @IBOutlet weak var CourseNameField: UITextField!
    @IBOutlet weak var AssignmentNameField: UITextField!
    @IBOutlet weak var AssignmentNotesField: UITextView!
    @IBOutlet weak var AssignmentDueDate: UIDatePicker!
    @IBOutlet weak var assignmentReminderSwitch: UISwitch!
    @IBOutlet weak var AddAssignmentButton: UIButton!
    
    var isEdit = false
    var editCourseName = ""
    var editAssignmentName = ""
    var editAssignmentNotes = ""
    var editDueDate = Date.distantPast
    var editCreatedDate = Date.distantPast
    var editCompleted = false
    
    var uniqueIdentifier = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set all fields if the assignment is being edited
        if isEdit == true{
            CourseNameField.text = editCourseName
            AssignmentNameField.text = editAssignmentName
            AssignmentDueDate.date = editDueDate
            AssignmentNotesField.text = editAssignmentNotes
            AddAssignmentButton.setTitle("Edit Assignment", for: .normal)
            self.title = "Edit"
            
            if #available(iOS 15, *) {
                if AssignmentDueDate.date <= Date.now{
                    assignmentReminderSwitch.isOn = false
                    AssignmentDueDate.isHidden = true
                }else{
                    let calendar = Calendar.current
                    let date = calendar.date(byAdding: .hour, value: 1, to: editCreatedDate)
                    
                    AssignmentDueDate.minimumDate = date
                    assignmentReminderSwitch.isOn = true
                    AssignmentDueDate.isHidden = false
                }
            }
        }else{
            assignmentReminderSwitch.isOn = false
            AssignmentDueDate.isHidden = true
        }
        
        //Initial setup
        NotificationCenter.default.addObserver(self, selector: #selector(AddAssignmentsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddAssignmentsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done , target: self, action: #selector(self.doneClicked))
        
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.cyan
        toolbar.setItems([flexSpace,doneButton], animated: true)

        CourseNameField.inputAccessoryView = toolbar
        AssignmentNameField.inputAccessoryView = toolbar
        AssignmentNotesField.inputAccessoryView = toolbar
        CourseNameField.autocapitalizationType = .sentences
        AssignmentNameField.autocapitalizationType = .sentences
        
        if #available(iOS 13.4, *) {
            AssignmentDueDate.preferredDatePickerStyle = .automatic
        }
        AssignmentDueDate.tintColor = .white
    }
    
    //Displays/hides the date picker depending on toggle status of the due date switch
    @IBAction func reminderSwitchValue(sender: UISwitch){
        if (assignmentReminderSwitch.isOn){
            AssignmentDueDate.minimumDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            AssignmentDueDate.isHidden = false;
        }else{
            AssignmentDueDate.isHidden = true;
        }
    }
    
    //Add or edit an assignment and schedule a notification if the due date switch is on
    @IBAction func addAssignment(_ sender: UIButton) {
        if(!assignmentReminderSwitch.isOn){
            AssignmentDueDate.minimumDate = Date.distantPast
            AssignmentDueDate.setDate(Date.distantPast, animated: true)
        }
        
        let assignmentItem = AssignmentItem(
            courseName: CourseNameField.text!,
            assigmentName: AssignmentNameField.text!,
            reminder: AssignmentDueDate.date,
            notes: AssignmentNotesField.text!,
            completed: editCompleted,
            createdAt: Date(),
            identifier: uniqueIdentifier,
            type: "assignment")
        
        if(assignmentItem.courseName == "" && assignmentItem.assigmentName == ""){
            CourseNameField.layer.borderColor = UIColor.red.cgColor
            CourseNameField.layer.borderWidth = 2.0
            AssignmentNameField.layer.borderColor = UIColor.red.cgColor
            AssignmentNameField.layer.borderWidth = 2.0
        }else if(assignmentItem.courseName == ""){
            AssignmentNameField.layer.borderColor = UIColor.clear.cgColor
            CourseNameField.layer.borderColor = UIColor.red.cgColor
            CourseNameField.layer.borderWidth = 2.0
        }else if(assignmentItem.assigmentName == ""){
            CourseNameField.layer.borderColor = UIColor.clear.cgColor
            AssignmentNameField.layer.borderColor = UIColor.red.cgColor
            AssignmentNameField.layer.borderWidth = 2.0
        }else{
            CourseNameField.layer.borderColor = UIColor.clear.cgColor
            AssignmentNameField.layer.borderColor = UIColor.clear.cgColor
            if (isEdit == true){
                assignmentItem.editAssignment()
            }else{
                assignmentItem.saveAssignment()
            }
            NotificationManager.instance.scheduleAssignmentNotification(
                course: CourseNameField.text!,
                assignment: AssignmentNameField.text!,
                due: AssignmentDueDate.date,
                identifier: uniqueIdentifier,
                completed: editCompleted)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // move the root view up by the distance of keyboard height
    @objc func keyboardWillShow(notification: NSNotification){
       var shouldMoveViewUp = false
       guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
       if (self.AssignmentNotesField .isFirstResponder){
           shouldMoveViewUp = true
       }
       if(shouldMoveViewUp == true){
           self.view.bounds.origin.y = 0 + keyboardSize.height
       }
    }
    
    //Return the view to orginal position when the keyboard is closed
    @objc func keyboardWillHide(notification: NSNotification){
        self.view.bounds.origin.y = 0
    }
    
    //Keyboard resignation functions
    @objc func doneClicked(){
        view.endEditing(true)
    }
    @IBAction func courseNameClose(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func assignmentClose(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
