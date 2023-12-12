import CoreData
import UIKit

class HomeScreenTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View Cell Related
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")

        //Search Bar Related
        searchBar.delegate = self
        
        // Loading itemArray From local Storage
        loadItems()
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
        
        if itemArray[indexPath.row].done{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    // MARK: - Table View Deleagte Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        refreshItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeScreenTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "itemLabel CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: "itemLabel", ascending: true)]
        loadItems(with: request)
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
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        do{
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
    
    
    
    
    
}
