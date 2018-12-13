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
    var itemArray = [ItemData]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Declare tableview delegate
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        
        //add items to items data array
        let itemAdded1 = ItemData()
        itemAdded1.itemAdded = "Shopping"
        itemArray.append(itemAdded1)
        
        let itemAdded2 = ItemData()
        itemAdded2.itemAdded = "Buy Eggs"
        itemArray.append(itemAdded2)
        
        let itemAdded3 = ItemData()
        itemAdded3.itemAdded = "Learn Shopping"
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        itemArray.append(itemAdded3)
        
        
        
        
        
        //Get array from user defaults
        if let items = defaults.array(forKey: "toDoListArrayKey") as? [ItemData] {
            itemArray = items
        }
    }

    //MARK: Tableview Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].itemAdded
        
        //writng a turnary expression
        //value = condition ? iftrue : iffalse
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Todo Item BarButton Method
    
    @IBAction func addNewTodoItemButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) {
            action in
            let itemAdded = ItemData()
            itemAdded.itemAdded = alertTextField.text!
            self.itemArray.append(itemAdded)
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

