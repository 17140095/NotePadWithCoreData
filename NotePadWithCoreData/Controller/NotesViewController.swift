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
        notesTableView.cornerRadius(radius: 10)
        
        notesTableView.register(NoteWithTitleCell.nib, forCellReuseIdentifier: NoteWithTitleCell.CELL_IDENTIFIER)
        notesTableView.register(NoteWithoutTitleCell.nib, forCellReuseIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER)
        
        search.cornerRadius(radius: search.frame.height/2)
      
        search.delegate = self
        
        data = viewModel.notes
        
        referesh()
        
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
        let data = viewModel.notes.filter { note in
            if let key = search.text, (note.title?.containsIgnoreCase(key) ?? false || note.desc?.containsIgnoreCase(key) ?? false){
                return true
            }
             return false
        }
        if let key = search.text, !key.isEmpty{
            self.data  = data
            
        }else{
            self.data = viewModel.getNotes()
        }
        handleBackgroundTableView()
    }

    private func referesh(){
        data = viewModel.getNotes()
        selectNote = nil
        search.text = ""
        handleBackgroundTableView()
    }
    private func handleBackgroundTableView(){
        if data.count<=0 {
            notesTableView.setBackgroundMessage(message: "No note found")
            print("Set background")
        }else{
            notesTableView.clearBackgroundMessage()
        }
        notesTableView.reloadData()
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note: NoteModel = data[indexPath.row]
    
        if let nt = note.title, !nt.isBlank(){
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithTitleCell
            cell?.noteTitle.text = note.title
            cell?.noteDescription.text = note.desc
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.date ?? Date())
            
            return cell ?? UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteWithoutTitleCell.CELL_IDENTIFIER, for: indexPath) as? NoteWithoutTitleCell
            cell?.noteTitle.text = note.desc
            cell?.noteDateTime.text = Utils.getStringFromDate(date: note.date ?? Date())
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.cornerRadius(radius: 10)
        cell.addSubview(CustomeKit.getTableViewSeparator(cell: cell))
      
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPathOfRow = notesTableView.indexPathForSelectedRow {
            selectNote = data[indexPathOfRow.row]
            selectNote?.display()
            
            performSegue(withIdentifier: "SingleNoteViewController", sender: self)
        }
    }
 
}

extension String {
    func containsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
    
    func getStrikeString()-> NSMutableAttributedString{
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}

extension UITableView{
    func setBackgroundMessage(message: String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.textColor = Constants.themeColor
        label.textAlignment = .center
        label.text = message
        
        self.separatorStyle = .none
        self.backgroundView = label
        self.backgroundColor = .systemBackground
    }
    func clearBackgroundMessage(){
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        self.backgroundColor = .systemGray6
        self.separatorStyle = .none
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

extension UIView{
    func cornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
