//
//  TaskItem.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//
import Foundation

struct TaskItem : Codable{
    var name:String?
    var reminder:Date?
    var notes:String?
    var completed:Bool
    var createdAt:Date
    var identifier:UUID
    var type:String
    
    func saveTask(){
        TaskDataManager.save(object: self, with: identifier.uuidString)
    }
    
    func deleteTask(){
        TaskDataManager.delete(fileName: identifier.uuidString)
    }
    
    func editTask(){
        deleteTask()
        saveTask()
    }
    
    mutating func markTaskAsCompleted(){
        self.completed = true
        TaskDataManager.save(object: self, with: identifier.uuidString)
    }
    
    mutating func markTaskAsIncomplete(){
        self.completed = false
        TaskDataManager.save(object: self, with: identifier.uuidString)
    }
}
