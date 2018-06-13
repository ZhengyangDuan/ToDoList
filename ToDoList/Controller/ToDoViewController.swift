//
//  ViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-08.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    let realm = try! Realm()
    var item: Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }

    //MARK: -declare table rows and data source
    //rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 1
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDo")
        if let cellItem = item?[indexPath.row]{
            cell.textLabel?.text = cellItem.title
            //change the done value
            cell.accessoryType = cellItem.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No item added"
        }
       
        return cell
        
    }
    
    //MARK: -declare tableview delegate
    //when cell been clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = item?[indexPath.row]{
            do{
                try realm.write {
                    selectedItem.done = !selectedItem.done
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    
       // item[indexPath.row].done = !item[indexPath.row].done
       // saveDataItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -add button function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
        
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveDataItem(item: Item){
//        do{
//            try realm.write {
//                realm.add(item)
//            }
//        }catch{
//            print("error" + "\(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems(){
        item = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

extension ToDoViewController: UISearchBarDelegate {
    
    //MARK: -searchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        item = item?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
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

