//
//  catagoryListVC.swift
//  ToDone
//
//  Created by BIT3016 on 12/12/23.
//

import UIKit

class CatagoryListVC : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}
