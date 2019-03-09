//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muhamad Aslan on 09/03/19.
//  Copyright © 2019 Muh Aslan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        showInputDialog(title: "Add a new category", inputPlaceholder: "Category name") { (text) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = text
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
    }

}

//MARK: - Add new todo

extension CategoryViewController {
    
    func showInputDialog(title: String? = nil,
                         actionTitle: String? = "Add",
                         inputPlaceholder: String? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = inputPlaceholder
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            guard let textField = alert.textFields?.first else {
                actionHandler?(nil)
                
                return
            }
            
            actionHandler?(textField.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Handle Selected Row

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Data Manipulation Metods

extension CategoryViewController {
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetch categories \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - TableView Datasource Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

//MARK: - Send Selected Row Index to Segue Destinations

extension CategoryViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
}
