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
                self.viewContext.automaticallyMergesChangesFromParent = true
                self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
                self.importInitialPokemonData()
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
/*
    ["name":"Arbok",
    "id":24,
    "type":Type.poison.rawValue,
    "subtype":Type.none.rawValue,
    "devolution":23,
    "evolution":-1
   ]
 */
    func importInitialPokemonData(){
        let data = PokemonData.init().info
        for dict in data{
            let pokemon = Pokemon(context: self.viewContext)
            if let name = dict["name"] as? String{
                pokemon.name = name
            }
            if let id = dict["id"] as? Int16{
                pokemon.id = id
            }
            if let type = dict["type"] as? Int16{
                pokemon.type = type
            }
            if let subtype = dict["subtype"] as? Int16{
                pokemon.subtype = subtype
            }
            if let devo = dict["devolution"] as? Int16{
                pokemon.devolution = devo
            }
            if let evo = dict["evolution"] as? Int16{
                pokemon.evolution = evo
            }


        }
        
        self.saveContext()
    }
        
    func fetchPokemonRequest() -> NSFetchRequest<Pokemon>{
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    
    func testStuff(){
        let bg = self.newBackgroundContext()
        self.saveContext(backgroundContext: bg)
        self.performBackgroundTask { (managedObjContext) in
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        }
    }
    
}
