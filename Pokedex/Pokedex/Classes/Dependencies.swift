//
//  Dependencies.swift
//  PointOfSales
//
//  Created by Daniel No on 5/14/21.
//

import Foundation
import CoreData

public final class Dependencies{
    lazy var dataContainer : DataContainer? = {
        let objectModel = NSManagedObjectModel()
        return DataContainer(name: "Pokedex", managedObjectModel: objectModel)
    }()
    
    
    static let sharedDependencies: Dependencies = {
        let instance = Dependencies()
        return instance
    }()
    
    func reset(){
        dataContainer = nil
    }
    
    private init(){
        
    }

    
}
