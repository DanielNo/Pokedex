//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Daniel No on 5/25/21.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    static let identifier = "pokemonCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
