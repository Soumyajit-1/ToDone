//
//  HomeScreenTableViewController.swift
//  ToDone
//
//  Created by Soumyajit Pal on 07/12/23.
//

import UIKit

class HomeScreenTableViewController: UITableViewController {
    var itemArray = [item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...3 {
            let newItem = item(itemLabel: "item1 added", isChecked: false)
            itemArray.append(newItem)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 35
        }
        print(dataFilePath)
        
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
//        itemArray = defaults.object(forKey: "ToDoneList") as! [item]
    }
    
    @IBAction func addBtn(_ sender: Any) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add Your ToDone Item", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField : UITextField)-> Void in
            textField.placeholder = "Add Your ToDone Item"
            alertTextField = textField
        })
        let action = UIAlertAction(title: "Add", style:.default, handler: {action in
            let newItem : item = item(itemLabel: alertTextField.text!, isChecked: false)
            self.itemArray.append(newItem)
            let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            }catch{
                
            }
            self.tableView.reloadData()
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.HomeTVCellLabel.text = itemArray[indexPath.row].itemLabel
        
        if itemArray[indexPath.row].isChecked{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].isChecked{
            itemArray[indexPath.row].isChecked = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            itemArray[indexPath.row].isChecked = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
