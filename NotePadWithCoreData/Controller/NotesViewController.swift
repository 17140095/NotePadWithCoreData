//
//  NotesViewController.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 31/01/2023.
//

import UIKit

class NotesViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addNote: UIButton!
    
    var viewModel: NoteViewModel = NoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.backgroundColor = UIColor.clear
        notesTableView.keyboardDismissMode = .onDrag
        notesTableView.keyboardDismissMode = .interactive
        
        notesTableView.register(NoteWithTitleCell.nib, forCellReuseIdentifier: NoteWithTitleCell.CELL_IDENTIFIER)
        notesTableView.register(NoteWithoutTitleCell.nib, forCellReuseIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER)
        
        search.layer.cornerRadius = search.frame.height/2
        search.clipsToBounds = true
        search.delegate = self
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note: Note = viewModel.notes[indexPath.row]
    
        if nil == note.title{
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithoutTitleCell
            cell?.noteTitle.text = note.description
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.dateTime)
            
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 10
            return cell ?? UITableViewCell()
        }else{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithTitleCell
            cell?.noteTitle.text = note.title
            cell?.noteDescription.text = note.description
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.dateTime)
            
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 10
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let thickness: CGFloat = 10.0
        let seprator = UIView(frame: CGRect(x: 0,
                                            y: cell.frame.height-thickness,
                                            width: cell.frame.width,
                                            height: thickness)
        )
        seprator.backgroundColor = UIColor.systemGray6
        seprator.clipsToBounds = true
        seprator.layer.cornerRadius = 10
        cell.addSubview(seprator)
      
        
    }
 
}
