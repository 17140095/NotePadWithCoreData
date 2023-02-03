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
    
    
   
    var note: Note?
    var isNewNote: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewNote {
            print("This is new note")
        }else{
            print("This is edit note")
        }
        titlefield.font = UIFont(name: "System", size: 20)
        titlefield.delegate = self
        titlefield.text = note?.title
        
        date.text = Utils.getStringFromDate(date: note?.dateTime ?? Date())
        
        textView.delegate = self
        textView.text = note?.description
        
        saveButton.tintColor = Constants.themeColor
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("Save Note tap")
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
