//
//  CoreDataManager.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 31/05/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager{
    
    class var shared: CoreDataManager {
        struct Singleton {
            static let instance = CoreDataManager()
        }
        return Singleton.instance
    }
    
    func saveFilmID (filmID: Int32) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Popcorn_Swirl", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        managedObject.setValue(Int32(filmID), forKey: "filmID")
        
        do {
            try managedContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFilmIDs() -> [FavouriteFilmModel]? {
        
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PopCorn_Swirl")
        
        do {
            let filmIDs = try managedContext.fetch(fetchRequest)
            var idObjects: [FavouriteFilmModel] = []
            
            filmIDs.forEach { (idObject) in
                idObjects.append(FavouriteFilmModel(object: idObject))
            }
            
            return idObjects
        } catch let error as NSError {
            print ("Could not fetch. \(error) \(error.userInfo)")
            return nil
        }
    }
    
    func deleteFilmID(filmID: Int32) {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Popcorn_Swirl")
        
        let predicate = NSPredicate(format: "filmID = %i", filmID)
        
        fetchRequest.predicate = predicate
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            print(result.count)
            
            if result.count > 0{
                for object in result {
                    print(object)
                    managedContext.delete(object as! NSManagedObject)
                }
                do {
                    try managedContext.save()
                }
            }
        }catch{
            
        }
    }
    
    
    func deleteAllSavedData() {
        //Remove all data saved with coreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Popcorn_Swirl", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                context.delete(result)
            }
            try context.save()
            
        } catch {
            
            print("fetch error -\(error.localizedDescription)")
        }
    }

}
