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
    
    var viewModel: NoteViewModel = NoteViewModel()
   
    var note: NoteModel?
    
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
        enableSaveButton(false)
        
        deleteButton.isHidden = (nil == note)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("Save Note tap")
    
        if nil == note {

            if viewModel.addNote(title: titlefield.text?.trim(), desc: textView.text.trim(), date: Date()) {
                let alert = UIAlertController(title: "Add Note", message: "Successfully saved note.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                })
                present(alert, animated: true)
            }else{
                let alert = CustomeKit.getAlert(title: "Error", message: "Note dose not saved. There some error.")
                present(alert, animated: true)
            }
            
           
        }else{
           
            if viewModel.updateNote(note: note!, title: titlefield.text?.trim(), desc: textView.text.trim(), date: Date()) {
                let alert = UIAlertController(title: "Update Note", message: "Successfully update note.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.view.tintColor = Constants.themeColor
                present(alert, animated: true)
            }else{
                let alert = CustomeKit.getAlert(title: "Error", message: "Note dose not update. There some error.")
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
        
        if let note = self.note, viewModel.deleteNote(note: note) {
            
            print("Note deleted")
            self.navigationController?.popViewController(animated: true)
        }else{
            print("No note deleted!")
        }
    }

}

extension SingleNoteViewController: UITextViewDelegate, UITextFieldDelegate{
   
    func textViewDidChange(_ textView: UITextView) {
        validateShowViews()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       validateShowViews()
    }
    
    func validateShowViews(){
        
        if nil == note{
            let shouldEnable = (titlefield.text?.isBlank() ?? true && textView.text.isBlank()) ? true: false
            enableSaveButton(!shouldEnable)
            
        }else{
            print("Edit show save call")
            enableSaveButton(true)
        }
        
        
    }
    
    func enableSaveButton(_ isEnable: Bool){
        if isEnable{
            saveButton.isEnabled = true
            saveButton.customView?.isUserInteractionEnabled = true
            saveButton.customView?.alpha = 1
        }else{
            saveButton.isEnabled = false
            saveButton.customView?.isUserInteractionEnabled = false
            saveButton.customView?.alpha = 0.66
        }
    }
}


extension String{
   
    func isBlank()-> Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    func trim()-> String{
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
