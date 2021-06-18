//
//  ViewController.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//

import UIKit
import CoreData

class ViewController: UICollectionViewController {
    let dataContainer = Dependencies.sharedDependencies.dataContainer
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    
    lazy var dataSource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = {
        let datasource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { (colView, indexPath, objectID) -> UICollectionViewCell? in
            let cell = colView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
            cell.imageView.image = UIImage(named: "1")
            return cell
        }
        
        return datasource
    }()
    
    enum Section {
      case main
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
        collectionView.dataSource = self.dataSource
        initializeFetchedResultsController()
//        self.applySnapshot()
    }

    
    func applySnapshot(animatingDifferences: Bool = true) {
      // 2
      var snapshot = NSDiffableDataSourceSnapshot<Section,NSManagedObjectID>()
      // 3
      snapshot.appendSections([.main])
      // 4
      snapshot.appendItems([])
      // 5
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
//                let fetchedPokemon = try dataContainer?.newBackgroundContext().fetch(request) as! [Pokemon]
//                print("\(fetchedPokemon.count) entries")
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }

        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    // New NSFetchedResultsControllerDelegate method to use with diffableDataSource.
    // If this method is implemented, no other delegate methods will be invoked according to documentation
    // This makes diffableDataSource usable alongside existing implementations for older ios versions.
    @available(iOS 13.0, *)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = self.collectionView.dataSource as? UICollectionViewDiffableDataSource<Section, NSManagedObjectID> else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>

        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)

        let shouldAnimate = self.collectionView.numberOfSections != 0
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
    

//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        tableView.beginUpdates()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        tableView.endUpdates()
//    }
    
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

extension ViewController : UICollectionViewDelegateFlowLayout{
    
    
}
