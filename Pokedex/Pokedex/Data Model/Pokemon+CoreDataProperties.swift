//
//  Pokemon+CoreDataProperties.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: Int16
    @NSManaged public var id: Int16

}

extension Pokemon : Identifiable {

}
