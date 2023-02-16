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
    
//    var imageName = TodoCellCheckImage.uncheck
    
    var selectedTodo: Todo?
    //var tableview: UITableView?
    var referesh: (()->Void)?
    
    static let CELL_IDENTIFIER = "TodoCell"
    static let nib = UINib(nibName: CELL_IDENTIFIER, bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let currTodo = selectedTodo{
            
            checkImage.image = UIImage(systemName: currTodo.isDone ? TodoCellCheckImage.check: TodoCellCheckImage.uncheck )
            
            if currTodo.isDone{
                todoTask.attributedText = currTodo.task?.getStrikeString()
            }else{
                todoTask.attributedText = nil
                todoTask.text = currTodo.task
            }
            

        }else{
            todoTask.text = selectedTodo?.task
            checkImage.image = UIImage(systemName: TodoCellCheckImage.uncheck)
            
        }
        checkImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onCheckImageTap(_:)))
        checkImage.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func onCheckImageTap(_ tapRecognizer: UITapGestureRecognizer?){
        print("Check image tapped")
        
        if selectedTodo?.isDone ?? true {
          print("Already done")
        }else{
            selectedTodo?.isDone = true
            CoreDB.getInstance().save()
            self.referesh?()
            
            //tableview?.reloadData()
        }
    }
    
}
struct TodoCellCheckImage{
    static let uncheck = "circlebadge"
    static let check = "checkmark.circle.fill"
}
