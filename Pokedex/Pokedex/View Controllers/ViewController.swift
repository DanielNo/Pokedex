//
//  ViewController.swift
//  Pokedex
//
//  Created by Daniel No on 5/18/21.
//

import UIKit

class ViewController: UIViewController {
    let dataContainer = Dependencies.sharedDependencies.dataContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let con = dataContainer{
            dataContainer?.saveContext()

        }
        dataContainer?.testStuff()
    }
    


}

