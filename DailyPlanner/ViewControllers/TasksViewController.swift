//
//  ViewController.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 2/25/19.
//  Copyright © 2019 Sam Ziegler. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    @IBOutlet weak var TasksTableView: UITableView!
    var datasourceArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Task screen loaded")
        
        TasksTableView.dataSource = self
        TasksTableView.delegate = self
        
        print(datasourceArray)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = datasourceArray[indexPath.row]
        cell.textLabel!.text = task.name
        //cell.textLabel!.text = task.name! + " " + task.notes!
        return cell
    }
}
