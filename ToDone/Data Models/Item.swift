//
//  Item.swift
//  ToDone
//
//  Created by Soumyajit Pal on 10/12/23.
//

import Foundation

class item : Codable {
    let itemLabel : String
    var isChecked : Bool
    
    init(itemLabel: String, isChecked: Bool) {
        self.itemLabel = itemLabel
        self.isChecked = isChecked
    }
}
