import CoreData
import UIKit
import SwipeCellKit

class HomeScreenTableViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : ItemsCategory?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View Cell Related
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")

        //Search Bar Related
        searchBar.delegate = self
        
        // Navigation Bar Title
        navigationItem.title = selectedCategory?.name

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
            let newItem = Item(context: self.context)
            newItem.itemLabel = alertTextField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! HomeTVCell
        cell.HomeTVCellLabel.text = itemArray[indexPath.row].itemLabel
        
        if itemArray[indexPath.row].done{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    // MARK: - Table View Deleagte Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        refreshItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateItems(at indexPath: IndexPath) {
        deleteItem(with: indexPath)
    }
    
}

// MARK: - UISearchBarDelegate Methods

extension HomeScreenTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "itemLabel CONTAINS[cd] %@", searchBar.text!)
        loadItems(predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    // MARK: - Data Manupulation Methods
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate = NSPredicate(format: "TRUEPREDICATE")){
        do{
            let andPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            let compoundPredicate = NSCompoundPredicate(format: "\(andPredicate) && \(predicate)")
            request.predicate = compoundPredicate
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func refreshItems(){
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteItem(with indexPath : IndexPath){
        self.context.delete(self.itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
}

