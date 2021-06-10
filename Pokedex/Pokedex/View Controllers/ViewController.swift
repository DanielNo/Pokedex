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
    
//    var collectionView : UICollectionView = {
//        let cv = UICollectionView(frame: .zero)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//          let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
//          let size = NSCollectionLayoutSize(
//            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
//            heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
//          )
//          let itemCount = isPhone ? 1 : 3
//          let item = NSCollectionLayoutItem(layoutSize: size)
//          let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
//          let section = NSCollectionLayoutSection(group: group)
//          section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//          section.interGroupSpacing = 10
//          // Supplementary header view setup
//          let headerFooterSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(20)
//          )
//          let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerFooterSize,
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .top
//          )
//          section.boundarySupplementaryItems = [sectionHeader]
//          return section
//        })
//        return cv
//    }()
    
    
    
    var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 10
        flowLayout.headerReferenceSize = CGSize(width: 100, height: 100)
        flowLayout.footerReferenceSize = CGSize(width: 100, height: 100)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    
    lazy var dataSource : UICollectionViewDiffableDataSource<Section,Pokemon> = {
        let datasource : UICollectionViewDiffableDataSource<Section,Pokemon> = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { (colView, indexPath, pokemon) -> UICollectionViewCell? in
            let cell = colView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath)
            return cell
        }
        
        return datasource
    }()
    
    enum Section {
      case main
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        initializeFetchedResultsController()
    }
}

extension ViewController : NSFetchedResultsControllerDelegate{
    func initializeFetchedResultsController() {
        if let request = dataContainer?.fetchPokemonRequest(){
            if let moc = dataContainer?.viewContext{
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "pokemon-cache")
                fetchedResultsController.delegate = self
            }
            
            do {
                let fetchedPokemon = try dataContainer?.newBackgroundContext().fetch(request) as! [Pokemon]
                print("\(fetchedPokemon.count) entries")
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

extension ViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    
    
    
}
