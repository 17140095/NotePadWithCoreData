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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlefield.font = UIFont(name: "System", size: 20)
        titlefield.delegate = self
        
        date.text = Utils.getStringFromDate(date: Date())
        
        saveButton.tintColor = Constants.themeColor
        

        textView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("Save Note tap")
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

extension SingleNoteViewController: UITextViewDelegate{
//    func textViewDidEndEditing(_ textView: UITextView) {
//        saveButton.isHidden = textView.text.isEmpty ? true: false
//    }
   
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isHidden = (titlefield.text?.isEmpty ?? true && textView.text.isEmpty) ? true: false
    }
}

extension SingleNoteViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isHidden = (titlefield.text?.isEmpty ?? true && textView.text.isEmpty) ? true: false
    }
}
