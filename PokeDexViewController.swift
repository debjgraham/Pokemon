//
//  PokeDexViewController.swift
//  Pokemon
//
//  Created by Deborah Graham on 9/3/17.
//  Copyright © 2017 Deborah Graham. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemons = getAllCaughtPokemons()
        uncaughtPokemons = gettAllUncaughtPokemons()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemons.count
        } else {
            return uncaughtPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = caughtPokemons[indexPath.row]
        } else {
            pokemon = uncaughtPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        
        return cell
    }




}
