//
//  ViewController.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-08.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var item: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        tableView.rowHeight = 80.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else{fatalError("dead")}
        title = selectedCategory!.name
        updateBar(with: colorHex)
            
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateBar(with: "1D9BF6")
    }
    
    func updateBar(with hexCode: String){
        guard let navi = navigationController?.navigationBar else{fatalError("navigationbar does not exist")}
        guard let barColor = UIColor(hexString: hexCode) else{fatalError("dead")}
        navi.tintColor = ContrastColorOf(barColor, returnFlat: true)
        navi.barTintColor = barColor
        searchBar.barTintColor = barColor
        navi.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(barColor, returnFlat: true)]
    }
    
    //MARK: -declare table rows and data source
    //rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 1
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cellItem = item?[indexPath.row]{
            cell.textLabel?.text = cellItem.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(item!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }else{
                
            }
            
            
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
    
    func loadItems(){
        item = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDelete = item?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemForDelete)
                }
            }catch{
                print("error occured \(error)")
            }
        }else{
            print("no such element")
        }
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

