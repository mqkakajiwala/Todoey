//
//  ViewController.swift
//  Todoey
//
//  Created by Mustafa on 13/12/2018.
//  Copyright © 2018 Mustafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var todoListTableView: UITableView!
    
    //MARK: Instance variables
    var itemArray = ["Shopping" , "Buy Eggs"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Declare tableview delegate
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        //Get array from user defaults
        if let items = defaults.array(forKey: "toDoListArrayKey") as? [String] {
            itemArray = items
        }
    }

    //MARK: Tableview Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Todo Item BarButton Method
    
    @IBAction func addNewTodoItemButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) {
            action in
            self.itemArray.append(alertTextField.text!)
            self.defaults.set(self.itemArray, forKey: "toDoListArrayKey")
            self.todoListTableView.reloadData()
        }
        
        alert.addTextField {
            textField in
            textField.placeholder = "Add Item here"
            alertTextField = textField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}

