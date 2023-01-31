//
//  TodoCell.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var todoTask: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
