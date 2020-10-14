//
//  DatabaseManager.swift
//  Geese-Swans
//
//  Created by Neestackich on 06.10.2020.
//

import UIKit
import CoreData

class DatabaseManager {
    
    
    // MARK: -Properties
    
    static let shared = DatabaseManager()
   
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    // MARK: -Methods
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    func coreDataIsEmpty() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Bird> = Bird.fetchRequest()
        
        do {
            if try context.count(for: fetchRequest) != 0 {
                return false
            }
        } catch {
            print("Count error")
        }
        
        return true
    }
    
    func addBirdToCoreData(size: Float, color: UIColor, name: String, type: String, x: Float, y: Float, lastMovementX: Float, lastMovementY: Float, isFlying: Bool) {
        let entity = NSEntityDescription.entity(forEntityName: "Bird", in: context)
        
        if let entity = entity {
            let bird = NSManagedObject(entity: entity, insertInto: context) as! Bird
            bird.size = size
            bird.color = color
            bird.name = name
            bird.type = type
            bird.isFlying = isFlying
            bird.x = x
            bird.y = y
            
            do {
                try context.save()
                print("New object '\(name)' saved")
            } catch {
                print("Save error")
            }
        }
    }
    
    func getCoreDataBirds() -> [Bird] {
        let fetchRequest: NSFetchRequest<Bird> = Bird.fetchRequest()
            
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Fetch error")
        }
        
        return []
    }
    
    func updateCoreDataBird() {
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func coreDataCleanUp(birds: [Bird]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for bird in birds {
            do {
                try context.delete(bird)
            } catch {
                print("Delete error")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("saved after delete")
        }
    }
}
