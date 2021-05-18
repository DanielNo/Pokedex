//
//  DataContainer.swift
//  
//
//  Created by Daniel No on 5/14/21.
//

import Foundation
import CoreData

// Apple recommends subclassing NSPersistentContainer, so we will try it that way.
/*
NSPersistentContainer is intended to be subclassed. Your subclass is a convenient place to put Core Data–related code like functions that :
 return subsets of data and calls to persist data to disk.
*/

public class DataContainer : NSPersistentContainer{
    
    public override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
        self.setupCoreDataStack()
    }
    
    public func setupCoreDataStack(){
        self.loadPersistentStores{ desc, error in
            if let err = error{
                fatalError("unable to load persistent stores")
            }else{
                print("core data stores loaded!")
            }
            
        }
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else {
            print("core data context : has no changes to save")
            return
        }
        do {
            try context.save()
            print("core data context : saved!")
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }

    // fetch request here
    
    func fetchPokemon(type : Int){
        
    }
    
    func testStuff(){
        let bg = self.newBackgroundContext()
        self.saveContext(backgroundContext: bg)
        self.performBackgroundTask { (managedObjContext) in
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        }
    }
    
}
