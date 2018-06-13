//
//  GroceryViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-11.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import CoreData

class GroceryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  category = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataItem()

    }
    
    //MARK: -DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "GroceryItem")
        cell.textLabel?.text = category[indexPath.row].name
        //cell.accessoryType = category[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexpath.row]
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newcategory = Category(context: self.context)
                newcategory.name = textField.text!
                //newcategory.done = false
                self.category.append(newcategory)
                self.saveDataItem()
                
            }else{
                print("error!")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveDataItem(){
        do{
            try self.context.save()
        }catch{
            print("error" + "\(error)")
        }
        self.tableView.reloadData()
    }
    func loadDataItem(request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            category = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func removeDataItem(position : Int){
        context.delete(category[position])
        category.remove(at: position)
        saveDataItem()
    }
    
    //MARK: -table view delegate method, direct to item list.
}
