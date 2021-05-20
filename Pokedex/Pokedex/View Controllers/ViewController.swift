//
//  ViewController.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    let dataContainer = Dependencies.sharedDependencies.dataContainer
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeFetchedResultsController()
    }
    
    func initializeFetchedResultsController() {
        if let request = dataContainer?.fetchPokemonRequest(){
            
            if let moc = dataContainer?.viewContext{
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController.delegate = self
                let objs = fetchedResultsController.fetchedObjects

            }
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }

        }
    }

    


}

