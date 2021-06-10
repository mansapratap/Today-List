//
//  RootViewController.swift
//  Today List
//
//  Created by Mansa Pratap Singh on 22/04/21.
//

import UIKit
import CoreData

class RootViewController: UITableViewController {
    
    // MARK:- Properties
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    // MARK:- Data Manipulation
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategory(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rootCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    // MARK:- Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "rootToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        let index = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categories[index!.row]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categories.remove(at: indexPath.row)
            saveCategories()
        }
    }
    
    // MARK:- IB Action
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "Add new item to list.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Now", style: .default) { [self] (action) in
            let newCategory = Category(context: context)
            newCategory.name = textField.text!
            categories.append(newCategory)
            saveCategories()
        }
        
        alert.addTextField { (text) in
            textField = text
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(alertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- The End
