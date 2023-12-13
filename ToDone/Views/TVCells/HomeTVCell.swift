//
//  HomeTVCell.swift
//  ToDone
//
//  Created by Soumyajit Pal on 07/12/23.
//

import UIKit
import SwipeCellKit
import CoreData

class HomeTVCell: SwipeTableViewCell {
    @IBOutlet weak var HomeTVCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
