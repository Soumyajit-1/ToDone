import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath ) as! HomeTVCell
        cell.delegate = self
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateItems(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }

    // MARK: - Data Manupulation Methods
    
    func updateItems(at indexPath: IndexPath){
        // Override AnyWhere
    }
    
}
