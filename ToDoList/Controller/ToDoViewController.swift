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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var  item = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDataItem()
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
                let newItem = Item()
                newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(item)
            try data.write(to: dataFilePath!)
        }catch{
            print("error" + "\(error)")
        }
        self.tableView.reloadData()
    }
    func loadDataItem(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {item = try decoder.decode([Item].self, from: data)
            }catch{
                print("error occured \(error)")
            }
        }
       
    }
    
    
}

