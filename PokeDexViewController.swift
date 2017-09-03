//
//  PokeDexViewController.swift
//  Pokemon
//
//  Created by Deborah Graham on 9/3/17.
//  Copyright © 2017 Deborah Graham. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
