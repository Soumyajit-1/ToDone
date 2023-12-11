//
//  HomeScreenTableViewController.swift
//  ToDone
//
//  Created by Soumyajit Pal on 07/12/23.
//

import UIKit

class HomeScreenTableViewController: UITableViewController {
    var itemArray = [item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View Cell Related
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        
        // Loading itemArray From local Storage
        loadItems()
    }
    
    
    // MARK: - Local Storage related operataion
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([item].self, from: data)
            }catch{
                print("Something went wrong")
            }
        }
        tableView.reloadData()
    }
    
    func refreshItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Somthing went wrong")
        }
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Button Actions
    
    @IBAction func addBtnAcn(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add Your ToDone Item", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField : UITextField)-> Void in
            textField.placeholder = "Add Your ToDone Item"
            alertTextField = textField
        })
        let action = UIAlertAction(title: "Add", style:.default, handler: {action in
            // Access Core Data Context
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item(context: context)
            newItem.itemLabel = alertTextField.text!
            self.itemArray.append(newItem)
            self.refreshItems()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // MARK: - Table View Deleagte Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].isChecked{
            itemArray[indexPath.row].isChecked = false
            refreshItems()
        }else{
            itemArray[indexPath.row].isChecked = true
            refreshItems()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
