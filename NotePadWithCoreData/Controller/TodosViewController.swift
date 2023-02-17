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
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    let viewModel = TodoViewModel()
    
    var data: [Todo] = [Todo]()
    var dataCompleted: [Todo] = [Todo]()
    var dataUnCompleted: [Todo] = [Todo]()
    var selectedTodo: Todo?
    
    var addAlertAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextField.appearance().tintColor = Constants.themeColor
        UITextView.appearance().tintColor = Constants.themeColor
        
        todosTableView.delegate = self
        todosTableView.dataSource = self
        todosTableView.register(TodoCell.nib, forCellReuseIdentifier: TodoCell.CELL_IDENTIFIER)
        todosTableView.sectionHeaderTopPadding = 0
                
        addButton.tintColor = Constants.themeColor
        
        search.delegate = self

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        referesh()
    }
    
    @IBAction func addTodoAction(_ sender: Any) {
        todoAlert(title: "Add Todo", updateTodo: nil)
    }
    
    @IBAction func deleteTodoAction(_ sender: Any) {
        if let st = self.selectedTodo{
            let alert = UIAlertController(title: "Success", message: "Successfully delete todo", preferredStyle: .alert)
            alert.view.tintColor = Constants.themeColor
            if viewModel.deleteTodo(todo: st){
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                referesh()
            }else{
                alert.title = "Error"
                alert.message = "There some error to delete todo"
            }
            self.present(alert, animated: true)
        }
    }
    
    func todoAlert(title: String, updateTodo: Todo?){
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.view.tintColor = Constants.themeColor
        alert.addTextField()
        alert.textFields?[0].placeholder = "Write task"
        alert.textFields?[0].accessibilityIdentifier = "addTodo"
        alert.textFields?[0].delegate = self
        
        if let todo = updateTodo{
            alert.textFields?[0].text = todo.task
        }
        
        addAlertAction = UIAlertAction(title: "Save", style: .default){_ in
            let task = alert.textFields?[0].text?.trim()
            if let t = task, !t.isEmpty{
                let res = (updateTodo != nil) ? (self.viewModel.updateTodo(todo: updateTodo!, task: t)) : (self.viewModel.addTodo(task: t))
                if res {
                    print("todo save")
                    self.referesh()
                }else{
                    print("todo not save")
                }
            }else{
                
                print("Alert task: \(task)")
            }
        }
        
        addAlertAction?.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(addAlertAction!)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
    
    func referesh(){
        data = viewModel.getTodos()
        dataCompleted = viewModel.getCompletedTodo(todos: data)
        dataUnCompleted = viewModel.getUncompletedTodo(todos: data)
        
        print("CompletedCount: \(dataCompleted.count), Uncompleted: \(dataUnCompleted.count)")
        search.text = ""
        selectedTodo = nil
        addAlertAction?.isEnabled = false
        enableDeleteButton(shouldEnable: false)
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
            label.textAlignment = .left
            label.backgroundColor = .systemGray6
            label.textColor = Constants.themeColor
            label.sizeToFit()
            
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
   
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.CELL_IDENTIFIER) as? TodoCell
        
        print("Section no: \(indexPath.section)")
        
        if indexPath.section == 0{
            let todo = dataUnCompleted[indexPath.row]
            cell?.selectedTodo = todo
        }else{
            let todo = dataCompleted[indexPath.row]
            cell?.selectedTodo = todo
        }
        
        cell?.referesh = referesh
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedTodo = indexPath.section == 0 ? dataUnCompleted[indexPath.row] : dataCompleted[indexPath.row]
       enableDeleteButton(shouldEnable: true)
        
        if indexPath.section == 0{
            todoAlert(title: "Update Todo", updateTodo: selectedTodo)
        }
    }
    
}

extension TodosViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.accessibilityIdentifier?.trim() == "searchTodo" {
            
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
        }else if textField.accessibilityIdentifier?.trim() == "addTodo" {
            addAlertAction?.isEnabled = !(textField.text?.isBlank() ?? true)
            print("Todo textfield")
        }else{
            print("No text field identifier matched")
        }
    }
    
    private func enableDeleteButton(shouldEnable: Bool) {
        if shouldEnable {
            deleteButton.isEnabled = true
            deleteButton.customView?.alpha = 1
        }else{
            deleteButton.isEnabled = false
            deleteButton.customView?.alpha = 0.66
        }
    }
}
