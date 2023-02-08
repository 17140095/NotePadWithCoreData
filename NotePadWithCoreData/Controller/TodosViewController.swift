//
//  TodosViewController.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 31/01/2023.
//

import UIKit

class TodosViewController: UIViewController {

    @IBOutlet weak var todosTableView: UITableView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let viewModel = TodoViewModel()
    
    var data: [Todo] = [Todo]()
    var dataCompleted: [Todo] = [Todo]()
    var dataUnCompleted: [Todo] = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextField.appearance().tintColor = Constants.themeColor
        UITextView.appearance().tintColor = Constants.themeColor
        
        todosTableView.delegate = self
        todosTableView.dataSource = self
        todosTableView.cornerRadius(radius: 10)
        todosTableView.register(TodoCell.nib, forCellReuseIdentifier: TodoCell.CELL_IDENTIFIER)
        todosTableView.sectionHeaderTopPadding = 0
                
        addButton.tintColor = Constants.themeColor
        
        search.delegate = self
        search.cornerRadius(radius: search.frame.height/2)
        
        referesh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        referesh()
    }
    
    @IBAction func addTodoAction(_ sender: Any) {
        
    }
    
    func referesh(){
        data = viewModel.getTodos()
        dataCompleted = viewModel.getCompletedTodo(todos: data)
        dataUnCompleted = viewModel.getUncompletedTodo(todos: data)
        
        print("CompletedCount: \(dataCompleted.count), Uncompleted: \(dataUnCompleted.count)")
        search.text = ""
        handleBackgroundTableView()
    }

    private func handleBackgroundTableView(){
        if data.count<=0 {
            todosTableView.setBackgroundMessage(message: "No todo found")
        }else{
            todosTableView.clearBackgroundMessage()
        }
        todosTableView.reloadData()
    }
}

extension TodosViewController: UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if section == 1{
            let header = UIView()
            let label = UILabel()
            label.frame.size.width = tableView.bounds.width
            label.frame.size.height = 40
            label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            
            label.text = "Completed"
            label.sizeToFit()
            label.textAlignment = .left
            label.backgroundColor = .systemGray6
            label.textColor = Constants.themeColor

            header.addSubview(label)
            header.clipsToBounds = true
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? dataUnCompleted.count : dataCompleted.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataCompleted.count>0 ? 2: 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.CELL_IDENTIFIER, for: indexPath) as? TodoCell
        
        print("Section no: \(indexPath.section)")
        
        if indexPath.section == 0{
            let todo = dataUnCompleted[indexPath.row]
            cell?.todoTask.attributedText = nil
            cell?.todoTask.text = todo.task
            cell?.imageName = TodoCellCheckImage.uncheck
        }else{
            let todo = dataCompleted[indexPath.row]
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: todo.task ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            cell?.todoTask.attributedText = attributeString
            cell?.imageName = TodoCellCheckImage.check
        }
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addSubview(CustomeKit.getTableViewSeparator(cell: cell))
        cell.cornerRadius(radius: 10)
    }
}

extension TodosViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let filterData = viewModel.getTodos().filter { todo in
            if let key = search.text, let task = todo.task, !key.isBlank(), task.containsIgnoreCase(key) {
                return true
            }
            return false
        }
        
        if !(search.text?.isBlank() ?? true) {
            data = filterData
            
        }else{
            data = viewModel.getTodos()
        }
        dataCompleted = viewModel.getCompletedTodo(todos: data)
        dataUnCompleted = viewModel.getUncompletedTodo(todos: data)
        handleBackgroundTableView()
    }
}
