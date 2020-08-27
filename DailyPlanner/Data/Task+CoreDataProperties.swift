//
//  Task+CoreDataProperties.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 8/26/20.
//  Copyright © 2020 Sam Ziegler. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var reminder: Date?
    @NSManaged public var notes: String?

}
