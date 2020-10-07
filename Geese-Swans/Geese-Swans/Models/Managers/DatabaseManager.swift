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
    
    
    // MARK: -Methods
    
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
    
    func addBirdToCoreData(size: Int16, color: String, name: String, type: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bird", in: context)
        
        if let entity = entity {
            let bird = NSManagedObject(entity: entity, insertInto: context) as! Bird
            bird.size = size
            bird.color = color
            bird.name = name
            bird.type = type
            
            do {
                try context.save()
                print("New object '\(name)' saved")
            } catch {
                print("Save error")
            }
        }
    }
    
    func getCoreDataBirds() -> [Bird] {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Bird> = Bird.fetchRequest()
            
            do {
                return try context.fetch(fetchRequest)
            } catch {
                print("Fetch error")
            }
            
            return []
        }
}
