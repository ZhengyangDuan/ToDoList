//
//  ViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-08.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import Foundation

class ToDoViewController: UITableViewController {
    
    var  item = [Item]()
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.title = "LALALA"
        item.append(newItem)
    }

    //MARK: -declare table rows and data source
    //rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Todo")
        cell.textLabel?.text = item[indexPath.row].title
        
        cell.accessoryType = item[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: -declare tableview delegate
    //when cell been clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item[indexPath.row].done = !item[indexPath.row].done
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -add button function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newItem = Item()
                newItem.title = textField.text!
                self.item.append(newItem)
                self.defaults.set(self.item, forKey: "ToDoItemList")
                self.tableView.reloadData()
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
}

