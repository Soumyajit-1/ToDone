import UIKit
import CoreData

class CatagoryListVC : UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [ItemsCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Table View Cell Related
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.register(UINib(nibName: "HomeTVCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
        // Loading itemArray From local Storage
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        cell.HomeTVCellLabel.text = categoryArray[indexPath.row].name
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    

}
