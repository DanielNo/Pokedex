//
//  ViewController.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let dataContainer = Dependencies.sharedDependencies.dataContainer
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeFetchedResultsController()
    }
}

extension ViewController : NSFetchedResultsControllerDelegate{
    func initializeFetchedResultsController() {
        if let request = dataContainer?.fetchPokemonRequest(){
            if let moc = dataContainer?.viewContext{
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController.delegate = self
                
            }
            
            do {
                let fetchedPokemon = try dataContainer?.newBackgroundContext().fetch(request) as! [Pokemon]
                print(fetchedPokemon)
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }

        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
    }
    
    // Row Changes (optional methods)
    /*
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
//            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
//            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
//            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
//            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        @unknown default:
            print("unknown future case")
        }
    }
    
    // Section Cahnges
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
 */

}

