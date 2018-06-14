//
//  GroceryViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-11.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import RealmSwift

class GroceryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        tableView.rowHeight = 80.0
    }
    
    //MARK: -DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category exist"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newcategory = Category()
                newcategory.name = textField.text!
                self.save(category: newcategory)
                
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
    
    // save data to database
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error" + "\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func load(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = categories?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(categoryForDelete)
                }
            }catch{
                print("error occured \(error)")
            }
        }else{
            print("no such element")
        }
        
    }
}
