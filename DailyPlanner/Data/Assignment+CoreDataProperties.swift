//
//  Assignment+CoreDataProperties.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 8/26/20.
//  Copyright © 2020 Sam Ziegler. All rights reserved.
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var course: String?
    @NSManaged public var name: String?
    @NSManaged public var due: Date?
    @NSManaged public var notes: String?

}
