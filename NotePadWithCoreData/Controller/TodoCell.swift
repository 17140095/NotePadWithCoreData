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
    
    var imageName = TodoCellCheckImage.uncheck
    
    //var selectedTodo: Todo?
    static let CELL_IDENTIFIER = "TodoCell"
    static let nib = UINib(nibName: CELL_IDENTIFIER, bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        checkImage.image = UIImage(systemName: imageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
struct TodoCellCheckImage{
    static let uncheck = "circlebadge"
    static let check = "checkmark.circle.fill"
}
