import UIKit
import CoreData

class CatagoryListVC : SwipeTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [ItemsCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Table View Cell Related
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        // Loading itemArray From local Storage
        loadItems()
    }
    
    
    // MARK: - Button actions
    
    @IBAction func addNewCatagory(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add Your New Catagory", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField : UITextField)-> Void in
            textField.placeholder = "Add Your New Catagory"
            alertTextField = textField
        })
        let action = UIAlertAction(title: "Add", style:.default, handler: {action in
            let newCategory : ItemsCategory = ItemsCategory(context: self.context)
            newCategory.name = alertTextField.text!
            self.categoryArray.append(newCategory)
            self.refreshItems()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! HomeTVCell
        cell.HomeTVCellLabel.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeScreenTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            print(categoryArray[indexPath.row])
        }
    }
    
    override func updateItems(at indexPath: IndexPath) {
        deleteItem(with: indexPath)
    }
        
    // MARK: - Data Manupulation Methods
    
    func refreshItems(){
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<ItemsCategory> = ItemsCategory.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteItem(with indexPath : IndexPath){
        self.context.delete(self.categoryArray[indexPath.row])
        self.categoryArray.remove(at: indexPath.row)
        do {
             try context.save()
         } catch {
             print("Error saving context after deletion: \(error)")
         }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade) // Update the table view
        tableView.endUpdates()
    }
    
}
