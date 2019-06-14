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
    
    func saveFilmID (filmID: Int32, object: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Popcorn_Swirl", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        managedObject.setValue(Int32(filmID), forKey: "filmID")
        managedObject.setValue(true, forKey: object)
        
        do {
            try managedContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFilmIDs() -> [FilmIDModel]? {
        
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        
        do {
            let filmIDs = try managedContext.fetch(fetchRequest)
            var idObjects: [FilmIDModel] = []
            
            filmIDs.forEach { (idObject) in
                idObjects.append(FilmIDModel(object: idObject))
            }
            
            return idObjects
        } catch let error as NSError {
            print ("Could not fetch. \(error) \(error.userInfo)")
            return nil
        }
    }
    
    func fetchIndividualButton(object: String) -> [FilmIDModel]? {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "\(object) = true", true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        fetchRequest.predicate = predicate
        
        do {
            let films = try managedContext.fetch(fetchRequest)
            var filmObjects: [FilmIDModel] = []
            
            films.forEach { (filmObject) in
                filmObjects.append(FilmIDModel(object: filmObject))
            }
            return filmObjects
        } catch let error as NSError {
            print ("Could not fetch \(error) \(error.userInfo)")
            return nil
        }
    }
    
    
    func fetchIndividualID(filmID: Int32) -> [FilmIDModel]? {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "filmID = %i", filmID)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        fetchRequest.predicate = predicate
        
        do {
            let films = try managedContext.fetch(fetchRequest)
            var filmObjects: [FilmIDModel] = []
            
            films.forEach { (filmObject) in
                filmObjects.append(FilmIDModel(object: filmObject))
            }
            return filmObjects
        } catch let error as NSError {
            print ("Could not fetch \(error) \(error.userInfo)")
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
            
            if result.count > 0{
                for object in result {
                    managedContext.delete(object as! NSManagedObject)
                }
                do {
                    try managedContext.save()
                }
            }
        }catch {
            let error = error as NSError
            fatalError("Could not delete. \(error), \(error.userInfo)")
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
    
    func updateButtonBool(object: String, updatedEntry: Bool, filmID: Int32) {
        //Update data held in coredata
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "filmID == %i", filmID)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            if let last = tasks.last {
                last.setValue(updatedEntry, forKey: object)
                
                do {
                    try managedContext.save()
                } catch {
                    let error = error as NSError
                    fatalError("could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print ("Could not fetch \(error). \(error.userInfo))")
        }
    }
    
    func updateWatchedComment (commentToAdd: String, filmID: Int32) {
        //Update watched comment held in coredata
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "filmID == %i", filmID)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            if let last = tasks.last {
                last.setValue(commentToAdd, forKey: "watchedComments")
                
                do {
                    try managedContext.save()
                } catch {
                    let error = error as NSError
                    fatalError("could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print ("Could not fetch \(error). \(error.userInfo))")
        }
    }
    
    func removeWatchedComment (filmID: Int32) {
        //Update watched comment held in coredata
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "filmID == %i", filmID)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Popcorn_Swirl")
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            if let last = tasks.last {
                last.setValue(nil, forKey: "watchedComments")
                
                do {
                    try managedContext.save()
                } catch {
                    let error = error as NSError
                    fatalError("could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print ("Could not fetch \(error). \(error.userInfo))")
        }
    }
    
}
