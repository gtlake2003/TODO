//
//  ViewController.swift
//  TODO
//
//  Created by 姚佳雯 on 2019/10/2.
//  Copyright © 2019年 ywd. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

extension TodoListViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<ItemCocoa> = ItemCocoa.fetchRequest()
        
//        request.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)
//        request.predicate = perdicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        request.sortDescriptors = [sortDescriptor]
        
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("从context获取数据错误：\(error)")
//        }
//
        tableView.reloadData()
//        print(searchBar.text!)
//        loadItems(with: request)
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

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()

//    var itemArray = [ItemCocoa]()
    var todoItems: Results<ItemRealm>?
    
    var selectedCategory: CategoryRealm? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
//        let newItem = Item()
//        newItem.title = "购买水杯"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "吃药"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "修改密码"
//        itemArray.append(newItem3)
//
//        for index in 4...120 {
//            let newItem = Item()
//            newItem.title = "第\(index)件事务"
//            itemArray.append(newItem)
//        }
        
//        print(dataFilePath!)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        let request: NSFetchRequest = ItemCocoa.fetchRequest()
//        loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "没有事项"
        }

//        cell.textLabel?.text = itemArray[indexPath.row].title
        
//        if itemArray[indexPath.row].done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
//        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemArray.count
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        
//        let title = itemArray[indexPath.row].title
//        itemArray[indexPath.row].setValue(title! + "-（已完成）", forKey: "title")
//        saveItems()
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
               print("保存完成状态失败：\(error)")
            }
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "添加项目", style: .default) {
            (action) in
//            let newItem = Item()
//            newItem.title = textField.text!
//            self.itemArray.append(newItem)
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
//            do {
//                let encoder = PropertyListEncoder()
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to:self.dataFilePath!)
//            } catch {
//                print("编码错误:\(error)")
//            }
//
  
            if let currentCategory = self.selectedCategory {
                print(currentCategory)
                do {
                    try self.realm.write {
                        let newItem = ItemRealm()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("保存Item发生错误\(error)")
                }
            }
//            let newItem = ItemCocoa(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField{(alertTextField) in
            
            alertTextField.placeholder = "创建一个新项目。。。"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        loadItems()
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//             print("编码错误:\(error)")
//        }
//        do {
//
//            try context.save()
//        } catch {
//            print("保存context错误：\(error)")
//        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ItemCocoa> = ItemCocoa.fetchRequest(), predicate: NSPredicate? = nil) {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//               print("解码错误:\(error)")
//            }
//        }
//        let request: NSFetchRequest<ItemCocoa> = ItemCocoa.fetchRequest()
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        do {
//            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//            if let addtionalPredicate = predicate {
//                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//            } else {
//                request.predicate = categoryPredicate
//            }
//
//            itemArray = try context.fetch(request)
//        } catch {
//            print("从context获取数据错误：\(error)")
//        }
        tableView.reloadData()
    }
}

