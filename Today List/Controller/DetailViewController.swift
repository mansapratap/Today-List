//
//  DetailViewController.swift
//  Today List
//
//  Created by Mansa Pratap Singh on 22/04/21.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {
    
    // MARK:- Properties
    var itemArray = [Item]()
    var selectedCategory: Category? {didSet {loadData()}}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        loadData()
    }
    
    // MARK:- Data Manipulation
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(request: NSFetchRequest<Item> = Item.fetchRequest()) {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].content
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark: .none
        return cell
    }
    
    // MARK:- Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemArray.remove(at: indexPath.row)
            saveData()
        }
    }
    
    // MARK:- IB Action
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "Add new item to list.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Now", style: .default) { [self] (action) in
            let newItem = Item(context: context)
            newItem.content = textField.text!
            newItem.isDone = false
            newItem.parentCategory = selectedCategory
            itemArray.append(newItem)
            saveData()
        }
        
        alert.addTextField { (text) in
            textField = text
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- The End
