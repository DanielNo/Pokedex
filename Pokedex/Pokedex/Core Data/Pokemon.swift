//
//  Pokemon.swift
//  Pokedex
//
//  Created by Daniel No on 5/19/21.
//

import Foundation
import UIKit
extension Pokemon{
    
    func image()-> UIImage{
        let name = self.name?.lowercased() ?? ""
        let image = UIImage(named: name)
        return image ?? UIImage()
    }
    
}
