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
    
    // TODO: Fix preloading
    public func setupCoreDataStack(){
        // Used this to fix preloading.
        // https://stackoverflow.com/questions/40093585/swift-3-preload-from-sql-files-in-appdelegate/40107699
        // Make sure file exists before loading stores.
//        self.loadInitialFile()
        self.loadPersistentStores{ desc, error in
            if let err = error{
                fatalError("unable to load persistent stores")
            }else{
                print("core data stores loaded!")
                self.viewContext.automaticallyMergesChangesFromParent = true
                self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
                // Uncomment to create sqlite db
//                self.prepopulateCoreDataEntries()
//                self.loadInitialFile()

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

}

// Data preloading
extension DataContainer{
    // Prepopulate Core Data from dictionary and save it.
    func prepopulateCoreDataEntries(_ fromDict:[[String:Any]] = PokemonData.init().info){
        let bgContext = self.newBackgroundContext()
        bgContext.perform {
            for dict in fromDict{
                let pokemon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: bgContext) as! Pokemon
//                let pokemon = Pokemon(context: self.viewContext)
                if let name = dict["name"] as? String{
                    pokemon.name = name
                }
                if let id = dict["id"] as? Int{
                    let idNum = Int16(id)
                    pokemon.id = idNum
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

            self.saveContext(backgroundContext: bgContext)

        }
    }
    
    // load local pokemon.sqlite file
    func loadInitialFile(){
        let storeURL = try! FileManager
                .default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Pokemon.sqlite")
        print(storeURL)
        if let sqlFile = Bundle.main.path(forResource: "Pokemon", ofType: "sqlite"){
            let url = URL(fileURLWithPath: sqlFile)
            do {
                print("copying file")
                try FileManager.default.copyItem(at: url, to: storeURL)
            } catch let error {
                print("error copying sql file : \(error.localizedDescription)")
            }
        }
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        self.persistentStoreDescriptions = [storeDescription]
    }

}

extension DataContainer{
    func fetchPokemonRequest() -> NSFetchRequest<Pokemon>{
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func fetchPokemonRequest(_ type : Type) -> NSFetchRequest<Pokemon>{
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        let pred = NSPredicate(format: "type == \(type.rawValue)")
//        let pred = NSPredicate(format: "type == %i", type.rawValue)
        fetchRequest.predicate = pred
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    func fetchPokemonRequest(_ name : String,_ type : Type) -> NSFetchRequest<Pokemon>{
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        var pred : NSPredicate
        if type == .all{
            pred = NSPredicate(format: "type < \(type.rawValue) AND name LIKE[cd] %@",name)
        }else{
            pred = NSPredicate(format: "type == \(type.rawValue) AND name LIKE[cd] %@",name)
        }
        fetchRequest.predicate = pred
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }

}
