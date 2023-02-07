//
//  SingleNoteViewController.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 02/02/2023.
//

import UIKit

class SingleNoteViewController: UIViewController {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var titlefield: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
   
    var note: NoteModel?
    //var isNewNote: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nil == note {
            print("This is new note")
        }else{
            print("This is edit note")
        }
        titlefield.font = UIFont(name: "System", size: 20)
        titlefield.delegate = self
        titlefield.text = note?.title
        
        date.text = Utils.getStringFromDate(date: note?.date ?? Date())
        
        textView.delegate = self
        textView.text = note?.desc
        
        saveButton.tintColor = Constants.themeColor
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("Save Note tap")
        
        
        
        if nil == note {
            let newN = NoteModel(entity: CoreDB.getInstance().notesEntity, insertInto: CoreDB.getInstance().context)
            newN.title = titlefield.text ?? ""
            newN.desc = textView.text ?? ""
            newN.date = Date()
            
            if CoreDB.getInstance().save(){
                let alert = UIAlertController(title: "Add Note", message: "Successfully saved note.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                })
//                let alert = Custome.getAlert(title: "Add Note", message: "Successfully saved note.")
                present(alert, animated: true)
            }else{
                let alert = Custome.getAlert(title: "Error", message: "Note dose not saved. There some error.")
                present(alert, animated: true)
            }
            
           
        }else{
            note?.title = titlefield.text ?? ""
            note?.desc = textView.text ?? ""
            note?.date = Date()
            if CoreDB.getInstance().save() {
                let alert = UIAlertController(title: "Update Note", message: "Successfully update note.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                })
                //let alert = Custome.getAlert(title: "Update Note", message: "Successfully update note.")
                present(alert, animated: true)
            }else{
                let alert = Custome.getAlert(title: "Error", message: "Note dose not update. There some error.")
                present(alert, animated: true)
            }
        }
        
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure to delete this note?", preferredStyle: .alert)
        alert.view.tintColor = Constants.themeColor
        
     
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.deleteNote()
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func deleteNote(){
        print("Note deleted")
        if let note = self.note {
            CoreDB.getInstance().context.delete(note)
        }
        self.navigationController?.popViewController(animated: true)
    }

}

extension SingleNoteViewController: UITextViewDelegate{
   
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isHidden = (titlefield.text?.isEmpty ?? true && textView.text.isEmpty) ? true: false
    }
}

extension SingleNoteViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isHidden = (titlefield.text?.isEmpty ?? true && textView.text.isEmpty) ? true: false
    }
}
