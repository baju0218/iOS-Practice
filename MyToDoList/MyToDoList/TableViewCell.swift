//
//  TableViewCell.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/03.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var completeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
