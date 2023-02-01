//
//  NoteWithoutTitleCell.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 31/01/2023.
//

import UIKit

class NoteWithoutTitleCell: UITableViewCell {

    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDateTime: UILabel!
 
    static let CELL_IDENTIFIER = "NoteWithoutTitleCell"
    static let nib = UINib(nibName: CELL_IDENTIFIER, bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.contentView.clipsToBounds = true
//        self.contentView.layer.cornerRadius = 10
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
