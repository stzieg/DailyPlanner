//
//  TasksViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var TasksTableView: UITableView!
    //create arrays to hold task items
    var taskItems = [TaskItem]();
    var completionArray = [[TaskItem](),[TaskItem]()]
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //populate and sort the full task item array and create a two-dimensional array separating tasks based on the completion status
        taskItems = TaskDataManager.loadAll(type: TaskItem.self).sorted(by: {$0.createdAt > $1.createdAt}).filter({$0.type == "task"});
        completionArray = [taskItems.filter{$0.completed == false},taskItems.filter{$0.completed == true}];
        
        //reload the table
        TasksTableView.reloadData();
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
        return completionArray[section].count;
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
    
    //Create a reusable cell for each task item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: indexPath);
        
        let task = completionArray[indexPath.section][indexPath.row]
        
        cell.textLabel!.text = task.name;
        cell.textLabel!.textColor = UIColor .white;
        cell.tintColor = UIColor .white;
        return cell;
    }
    
    //this allows the user to mark a task complete by swiping right on the table cell
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task = self.completionArray[indexPath.section][indexPath.row]

        if task.completed == false{
            let complete = UIContextualAction(style: .destructive,
                                              title: "complete",
                                              handler: {(ac:UIContextualAction, view:UIView, success:(Bool)->Void) in
                task.markTaskAsCompleted();
                
                //Cancel notification if the task is completed
                NotificationManager.instance.cancelNotification(identifier: task.identifier)
                
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
                task.markTaskAsIncomplete();
                
                //reschedule the notification if it's incomplete
                NotificationManager.instance.scheduleTaskNotification(
                    name: task.name!,
                    due: task.reminder!,
                    identifier: task.identifier,
                    completed: task.completed)
                
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
            let task = self.completionArray[indexPath.section][indexPath.row]
            task.deleteTask();
            
            //cancel notification if the task is deleted
            NotificationManager.instance.cancelNotification(identifier: task.identifier)
            
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
        guard segue.identifier == "editTaskCell" else { return }
        guard let atvc = segue.destination as? AddTasksViewController else { return }

        if let indexPath = TasksTableView.indexPathForSelectedRow{
            let task = self.completionArray[indexPath.section][indexPath.row]
            atvc.isEdit = true
            atvc.editTaskName = task.name ?? ""
            atvc.editReminder = task.reminder!
            atvc.editCreatedDate = task.createdAt
            atvc.editTaskNotes = task.notes ?? ""
            atvc.uniqueIdentifier = task.identifier
            atvc.editCompleted = task.completed
        }
     }
}
