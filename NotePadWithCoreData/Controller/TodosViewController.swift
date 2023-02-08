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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextField.appearance().tintColor = Constants.themeColor
        UITextView.appearance().tintColor = Constants.themeColor
        
        todosTableView.delegate = self
        todosTableView.dataSource = self
        todosTableView.cornerRadius(radius: 10)
        todosTableView.register(TodoCell.nib, forCellReuseIdentifier: TodoCell.CELL_IDENTIFIER)
        
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
        search.text = ""
        handleBackgroundTableView()
    }

    private func handleBackgroundTableView(){
        if data.count<=0 {
            todosTableView.setBackgroundMessage(message: "No todo found")
            print("Set todo background")
        }else{
            todosTableView.clearBackgroundMessage()
        }
        todosTableView.reloadData()
    }
}

extension TodosViewController: UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        viewModel.getCompletedTodo().count>0 ? 2: 1
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let todo = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.CELL_IDENTIFIER, for: indexPath) as? TodoCell
        cell?.todoTask.text = todo.task
        
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
        handleBackgroundTableView()
    }
}
