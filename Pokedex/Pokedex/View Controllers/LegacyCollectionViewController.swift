//
//  ViewController.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//

import UIKit
import CoreData

class LegacyCollectionViewController: UICollectionViewController {
    let dataContainer = Dependencies.sharedDependencies.dataContainer
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for pokemon"
        return searchController
    }()
        
    var filteredItems : [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initializeFetchedResultsController()
        self.navigationItem.searchController = searchController
    }
    
    func setupCollectionView(){
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: 195, height: 200)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = flowLayout
        
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

    }

}

extension LegacyCollectionViewController : NSFetchedResultsControllerDelegate{
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
    
    
    // Legacy implementation

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }
    
    // Row Changes (optional methods)
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    // Section Changes
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
    }
 

}

extension LegacyCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow : CGFloat = 3.0
        let w : CGFloat = CGFloat(UIScreen.main.bounds.width/numberOfItemsPerRow)
        let h : CGFloat = w
        let size = CGSize(width: w, height: h)
        return size
    }
    
}

extension LegacyCollectionViewController : UISearchControllerDelegate{
    
    
}
extension LegacyCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        
        if let fetched = self.fetchedResultsController.fetchedObjects{
            var results : [Pokemon]
            if filteredItems.count > 0{
                results = filteredItems
            }else{
                results = fetched
            }
            let pokemon = results[indexPath.row]
            let id = pokemon.id
            cell.imageView.image = UIImage(named: "\(id)")
            cell.backgroundColor = .systemYellow
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDataSource
extension LegacyCollectionViewController{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredItems.count > 0{
            return filteredItems.count
        }else{
            return self.fetchedResultsController.fetchedObjects?.count ?? 0
        }
    }
}

extension LegacyCollectionViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), let fetched = self.fetchedResultsController.fetchedObjects else{
            return
        }
        if text.count == 0{
            filteredItems = []
        }else{
            let searchMatches = fetched.filter { pokemon in
                if let name = pokemon.name?.lowercased(){
                    return name.contains(text)
                }else{
                    return false
                }
            }
            filteredItems = searchMatches
        }
        collectionView.reloadData()
    }
    
    
}
