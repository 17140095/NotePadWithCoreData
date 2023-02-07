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
    var data: [NoteModel] = [NoteModel]()
    
    var selectNote: NoteModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITextField.appearance().tintColor = Constants.themeColor
        UITextView.appearance().tintColor = Constants.themeColor
        
        addNote.tintAdjustmentMode = .normal
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.backgroundColor = UIColor.clear
        notesTableView.keyboardDismissMode = .onDrag
        notesTableView.keyboardDismissMode = .interactive
        notesTableView.layer.cornerRadius = 10
        notesTableView.clipsToBounds = true
        
        notesTableView.register(NoteWithTitleCell.nib, forCellReuseIdentifier: NoteWithTitleCell.CELL_IDENTIFIER)
        notesTableView.register(NoteWithoutTitleCell.nib, forCellReuseIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER)
        
        search.layer.cornerRadius = search.frame.height/2
      
        search.clipsToBounds = true
        search.delegate = self
        
        data = viewModel.notes
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        referesh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.tintColor = Constants.themeColor
        backButton.title = "Notes"
        navigationItem.backBarButtonItem = backButton
        
        if segue.destination is SingleNoteViewController, nil != selectNote {
            let vc = segue.destination as? SingleNoteViewController
            vc?.note = selectNote
        }
    
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       // print("Search happing.....")
        print("All count: \(viewModel.notes.count)")
        let data = viewModel.notes.filter { note in
            print("Title: \(note.title)\tDescription: \(note.desc)\t searchKey: \(search.text)\n")
            if let key = search.text, (note.title?.containsIgnoreCase(key) ?? false || note.desc?.containsIgnoreCase(key) ?? false){
                return true
            }
             return false
        }
        print("filter count: \(data.count)")
        if let key = search.text, !key.isEmpty{
            print("Filter note check")
            self.data  = data
            if data.count<=0 {
                notesTableView.setBackgroundMessage(message: "No note found")
                print("Set background")
            }else{
                notesTableView.clearBackgroundMessage()
            }
        }else{
            self.data = viewModel.notes
            notesTableView.clearBackgroundMessage()
        }
        
        self.notesTableView.reloadData()
    }

    private func referesh(){
        data = viewModel.getNotes()
        selectNote = nil
        notesTableView.reloadData()
        notesTableView.separatorInset = UIEdgeInsets.zero
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note: NoteModel = data[indexPath.row]
    
        if nil == note.title{
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithoutTitleCell
            cell?.noteTitle.text = note.description
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.date ?? Date())
            
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 10
            return cell ?? UITableViewCell()
        }else{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithTitleCell
            cell?.noteTitle.text = note.title
            cell?.noteDescription.text = note.desc
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.date ?? Date())
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPathOfRow = notesTableView.indexPathForSelectedRow {
            selectNote = data[indexPathOfRow.row]
            print("Selected Row")
            selectNote?.display()
            
            performSegue(withIdentifier: "SingleNoteViewController", sender: self)
        }
    }
 
}

extension String {
    func containsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
}

extension UITableView{
    func setBackgroundMessage(message: String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.textColor = .black
        label.textAlignment = .center
        label.text = message
        
        self.backgroundView = label
        self.backgroundColor = .white
    }
    func clearBackgroundMessage(){
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        self.backgroundColor = .systemGray6
    }
}

extension UIColor {
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
