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
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for pokemon"
        return searchController
    }()
    
    
    lazy var dataSource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = {
        let datasource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { (colView, indexPath, objectID) -> UICollectionViewCell? in
            let cell = colView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
//            print(objectID)
            let obj = self.dataContainer?.viewContext.object(with: objectID) as! Pokemon
            let id = obj.id
//            print(id)
            cell.imageView.image = UIImage(named: "\(id)")
            return cell
        }
        
        return datasource
    }()
    
    enum Section {
      case main
    }
    
    var originalItems : [NSManagedObjectID] {
        get{
            return self.fetchedResultsController.fetchedObjects?.compactMap {
                return $0.objectID
            } ?? []

        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.applySnapshot()
        initializeFetchedResultsController()
        self.navigationItem.searchController = searchController
    }
    
    func setupCollectionView(){
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
        collectionView.dataSource = self.dataSource
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = flowLayout

    }

    
    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = NSDiffableDataSourceSnapshot<Section,NSManagedObjectID>()
      snapshot.appendSections([.main])
      snapshot.appendItems([])
      dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension ViewController : NSFetchedResultsControllerDelegate{
    func initializeFetchedResultsController() {
        if let request = dataContainer?.fetchPokemonRequest(), let moc = dataContainer?.viewContext{
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController.delegate = self
            
            do {
                let fetchedPokemon = try dataContainer?.newBackgroundContext().fetch(request) as! [Pokemon]
                print("\(fetchedPokemon.count) entries")
                try fetchedResultsController.performFetch()
                if let fetched = fetchedResultsController.fetchedObjects{
//                    print(fetched)
                }
                
            } catch let err{
                print(err.localizedDescription)
            }

        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    // New NSFetchedResultsControllerDelegate method to use with diffableDataSource.
    // If this method is implemented, no other delegate methods will be invoked according to documentation
    // This makes diffableDataSource usable alongside existing implementations for older ios versions.
    // Simplest way to implement this method is to apply the "snapshot variable" to the collectionview's datasource.
    @available(iOS 13.0, *)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = self.collectionView.dataSource as? UICollectionViewDiffableDataSource<Section, NSManagedObjectID> else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }
//        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
//        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
//
//        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
//            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
//                return nil
//            }
//            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
//            return itemIdentifier
//        }
//        snapshot.reloadItems(reloadIdentifiers)
//
//        let shouldAnimate = self.collectionView.numberOfSections != 0
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: false)
    }
    
    // Legacy implementation

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

extension ViewController : UISearchControllerDelegate{
    
    
}

extension ViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), let fetched = self.fetchedResultsController.fetchedObjects else{
            return
        }
        var items : [NSManagedObjectID] = []
        if text.count == 0{
            items = self.originalItems
        }else{
            let filteredItems = fetched.filter { pokemon in
                if let name = pokemon.name?.lowercased(){
                    return name.contains(text)
                }else{
                    return false
                }
            }.compactMap {
                return $0.objectID
            }
            items = filteredItems
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,NSManagedObjectID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    
    
}
