//
//  ViewController.swift
//  Todoey
//
//  Created by Mustafa on 13/12/2018.
//  Copyright © 2018 Mustafa. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    @IBOutlet weak var todoListTableView: UITableView!
    
    //MARK: - Instance variables
    var itemArray = [ItemData]()
    let defaults = UserDefaults.standard
    var selectedCategory: Category?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Declare tableview delegate
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //Get array from user defaults
        if let items = defaults.array(forKey: "toDoListArrayKey") as? [ItemData] {
            itemArray = items
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        
    }
    
    //MARK: - Add New Todo Item BarButton Method
    
    @IBAction func addNewTodoItemButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) {
            action in
            
            //create a staging context to create data.
            let newItemAdded = ItemData(context: self.context)
            
            newItemAdded.itemAdded = alertTextField.text!
            newItemAdded.done = false
            newItemAdded.parentCategory = self.selectedCategory
            self.itemArray.append(newItemAdded)
            
            
            self.saveItems()
            
        }
        
        alert.addTextField {
            textField in
            textField.placeholder = "Add Item here"
            alertTextField = textField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        //save items data to core data entity
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.todoListTableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ItemData> = ItemData.fetchRequest(), predicate: NSPredicate? = nil) {
        //fetch request from coredata to load the data.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching request \(error)")
        }
        
        self.todoListTableView.reloadData()
    }
    
    
    
}

//MARK: - Search Bar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ItemData> = ItemData.fetchRequest()
        let predicate = NSPredicate(format: "itemAdded CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemAdded", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
        
    }
    
}

