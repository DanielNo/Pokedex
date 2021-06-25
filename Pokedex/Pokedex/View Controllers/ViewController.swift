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
    
    enum Section : Int {
        case main
    }
    
    var originalItems : [NSManagedObjectID] {
        get{
            return self.fetchedResultsController.fetchedObjects?.compactMap {
                return $0.objectID
            } ?? []

        }
    }
    
    lazy var dataSource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = {
        let datasource : UICollectionViewDiffableDataSource<Section,NSManagedObjectID> = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { (colView, indexPath, objectID) -> UICollectionViewCell? in
                let cell = colView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
    //            print(objectID)
                let obj = self.dataContainer?.viewContext.object(with: objectID) as! Pokemon
                let id = obj.id
    //            print(id)
                cell.imageView.image = UIImage(named: "\(id)")
                cell.backgroundColor = .systemRed
                return cell
        }
        return datasource
    }()

    let reuseID = "reuseId"
//    static let categoryHeaderId = "categoryHeaderId"

    // Use .absolute for exact pixel values
    // Use .fractionalWidth & .fractionalHeight for percentage of screen size.
    var layout : UICollectionViewCompositionalLayout = {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize,supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.supplementaryItems = []
//        group.supplementaryItems = UICollectionReusableView

        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar()
        setupCollectionView()
        configureHeader()
        self.applySnapshot()
        initializeFetchedResultsController()
        self.navigationItem.searchController = searchController
    }
    
    func configureHeader(){
        self.dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            let header: PokemonTitleCollectionReusableView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.reuseID, for: indexPath) as! PokemonTitleCollectionReusableView
            header.backgroundColor = .lightGray

//            if let section = self.currentSnapshot?.sectionIdentifiers[indexPath.section] {
//                header.label.text = "\(section.headerItem.titleHeader)"
//            }
            return header
        }

        
    }
    
    
    func setupCollectionView(){
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        self.collectionView.register(PokemonTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.reuseID)
        collectionView.dataSource = self.dataSource
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.backgroundColor = .systemRed
//        self.searchController.searchBar.backgroundColor = .systemYellow
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = NSDiffableDataSourceSnapshot<Section,NSManagedObjectID>()
      snapshot.appendSections([.main])
      snapshot.appendItems([])
      dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupStatusBar(){
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.systemBackground
            view.addSubview(statusBar)
//            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }

    }

}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.reuseID, for: indexPath) as! PokemonTitleCollectionReusableView
        headerView.textLabel.text = "my header"
        
        return headerView
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
