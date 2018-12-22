//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mustafa on 15/12/2018.
//  Copyright © 2018 Mustafa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //Declare Properties here
    @IBOutlet weak var categoryTableView: UITableView!
    
    //Declare instance variables here
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadCategories()
    }
    
    
    //MARK: - Tableview Datasource methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - Tableview delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let selectedIndexPath = categoryTableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[selectedIndexPath.row]
        }
        
        
    }
    
    //MARK: - Bar Button Item Button Pressed
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = alertTextfield.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (textField) in
            alertTextfield = textField
            alertTextfield.placeholder = "Add a new category"
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.categoryTableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
           categoryArray = try context.fetch(request)
        } catch {
            print("Error fetch request \(error)")
        }
        
        self.categoryTableView.reloadData()
    }
}
