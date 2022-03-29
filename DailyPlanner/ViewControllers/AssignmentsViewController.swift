//
//  AssignmentsViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class AssignmentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var AssignmentsTableView: UITableView!
    
    //create arrays to hold assignments
    var assignmentItems = [AssignmentItem]();
    var assignCompletionArray = [[AssignmentItem](),[AssignmentItem]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //populate and sort the full assignment item array and create a two-dimensional array separating tasks based on the completion status
        assignmentItems = AssignmentDataManager.loadAll(type: AssignmentItem.self).sorted(by: {$0.createdAt > $1.createdAt}).filter({$0.type == "assignment"});
        assignCompletionArray = [assignmentItems.filter{$0.completed == false},assignmentItems.filter{$0.completed == true}];
        
        //reload the table
        AssignmentsTableView.reloadData();
    }
    
    //load the view
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad();
    }
    
    //define the number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    //define the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignCompletionArray[section].count;
    }

    //name the sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    return "To Do"
                }
            case 1:
                if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                    return "Completed"
                }
            default:
                return nil
        }
        return nil
    }
    
    //set the style for the table view headers
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
    }
    
    //Create a reusable cell for each assignment item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentItemCell", for: indexPath);
        
        let assignment = assignCompletionArray[indexPath.section][indexPath.row]
        
        cell.textLabel!.text = assignment.courseName! + " - " + assignment.assigmentName!;
        cell.textLabel!.textColor = UIColor .white;
        cell.tintColor = UIColor .white;
        return cell;
    }
    
    //this allows the user to mark a task complete by swiping right on the table cell
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var assignment = self.assignCompletionArray[indexPath.section][indexPath.row]
        if assignment.completed == false{
            let complete = UIContextualAction(style: .destructive,
                                              title: "complete",
                                              handler: {(ac:UIContextualAction, view:UIView, success:(Bool)->Void) in
                assignment.markAssignmentAsCompleted();
                
                //Cancel notification if the assignment is marked as complete
                NotificationManager.instance.cancelNotification(identifier: assignment.identifier)
                
                self.viewDidLoad();
                success(true);
            });
            complete.backgroundColor = UIColor(red: 23.0/255.0, green: 221.0/255.0, blue: 220.0/255.0, alpha: 0.5);
            if #available(iOS 13.0, *){
                let icon = UIImage(systemName: "checkmark");
                complete.image = icon;
            };
            return UISwipeActionsConfiguration(actions: [complete]);
        }else{
            let incomplete = UIContextualAction(style: .destructive,
                                                title: "undo",
                                                handler: {(ac:UIContextualAction, view:UIView, success:(Bool)->Void) in
                assignment.markAssignmentAsIncomplete();
                
                //Reschedule notification if the assignment is marked as incomplete
                NotificationManager.instance.scheduleAssignmentNotification(
                    course: assignment.courseName!,
                    assignment: assignment.assigmentName!,
                    due: assignment.reminder!,
                    identifier: assignment.identifier,
                    completed: assignment.completed)
                
                self.viewDidLoad();
                success(true);
            });
            incomplete.backgroundColor = UIColor(red: 23.0/255.0, green: 221.0/255.0, blue: 220.0/255.0, alpha: 0.5);
            return UISwipeActionsConfiguration(actions: [incomplete]);
        }
    }
    
    //This will allow the user to delete an item by swiping left on the table cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                        title: "delete",
                                        handler: {(ac:UIContextualAction, view:UIView, success:(Bool)->Void) in
            let assignment = self.assignCompletionArray[indexPath.section][indexPath.row]
            assignment.deleteAssignment();
            
            //Cancel the notification if the assignment is deleted
            NotificationManager.instance.cancelNotification(identifier: assignment.identifier)
            
            self.viewDidLoad();
            success(true);
        });
        delete.backgroundColor = UIColor.red;
        if #available(iOS 13.0, *) {
            let icon = UIImage(systemName: "trash");
            delete.image = icon;
        };
        return UISwipeActionsConfiguration(actions: [delete]);
    }
    
    //prepare for edit segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editAssignmentCell" else { return }
        guard let aavc = segue.destination as? AddAssignmentsViewController else { return }

        if let indexPath = AssignmentsTableView.indexPathForSelectedRow{
            let assignment = self.assignCompletionArray[indexPath.section][indexPath.row]
            aavc.isEdit = true
            aavc.editCourseName = assignment.courseName ?? ""
            aavc.editAssignmentName = assignment.assigmentName ?? ""
            aavc.editDueDate = assignment.reminder!
            aavc.editCreatedDate = assignment.createdAt
            aavc.editAssignmentNotes = assignment.notes ?? ""
            aavc.uniqueIdentifier = assignment.identifier
            aavc.editCompleted = assignment.completed
        }
     }
}
