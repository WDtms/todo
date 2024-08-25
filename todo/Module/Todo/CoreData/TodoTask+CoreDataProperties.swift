//
//  TodoTask+CoreDataProperties.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//
//

import Foundation
import CoreData


extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var id: Int64
    @NSManaged public var todo: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var order: Int16

}

extension TodoTask : Identifiable {

}
