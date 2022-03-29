//
//  AssignmentItem.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import Foundation

struct AssignmentItem : Codable{
    var courseName:String?
    var assigmentName:String?
    var reminder:Date?
    var notes:String?
    var completed:Bool
    var createdAt:Date
    var identifier:UUID
    var type:String
    
    func saveAssignment(){
        AssignmentDataManager.save(object: self, with: identifier.uuidString)
    }
    
    func deleteAssignment(){
        AssignmentDataManager.delete(assignmentFileName: identifier.uuidString)
    }
    
    func editAssignment(){
        deleteAssignment()
        saveAssignment()
    }
    
    mutating func markAssignmentAsCompleted(){
        self.completed = true
        AssignmentDataManager.save(object: self, with: identifier.uuidString)
    }
    
    mutating func markAssignmentAsIncomplete(){
        self.completed = false
        AssignmentDataManager.save(object: self, with: identifier.uuidString)
    }
}
