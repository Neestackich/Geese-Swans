//
//  Bird+CoreDataProperties.swift
//  Geese-Swans
//
//  Created by Neestackich on 08.10.2020.
//
//

import Foundation
import CoreData


extension Bird {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bird> {
        return NSFetchRequest<Bird>(entityName: "Bird")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var isFlying: Bool
    @NSManaged public var name: String?
    @NSManaged public var size: Float
    @NSManaged public var type: String?
    @NSManaged public var x: Float
    @NSManaged public var y: Float

}

extension Bird : Identifiable {

}
