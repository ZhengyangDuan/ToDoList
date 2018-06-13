//
//  ViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-08.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  item = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadDataItem()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK: -declare table rows and data source
    //rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDo")
        cell.textLabel?.text = item[indexPath.row].title
        //change the done value
        cell.accessoryType = item[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    //MARK: -declare tableview delegate
    //when cell been clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        item[indexPath.row].done = !item[indexPath.row].done
        saveDataItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -add button function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.belongsToCategory = self.selectedCategory
                self.item.append(newItem)
                self.saveDataItem()
                
            }else{
                print("error!")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveDataItem(){
        //declare encorder
        
        do{
           try self.context.save()
        }catch{
            print("error" + "\(error)")
        }
        self.tableView.reloadData()
    }
    func loadDataItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "belongsToCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        do {
            item = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func removeDataItem(position : Int){
        context.delete(item[position])
        item.remove(at: position)
        saveDataItem()
    }
}

extension ToDoViewController: UISearchBarDelegate {
    
    //MARK: -searchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate  = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadDataItem(with: request, predicate : predicate)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDataItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

