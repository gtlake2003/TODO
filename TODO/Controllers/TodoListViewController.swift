//
//  ViewController.swift
//  TODO
//
//  Created by 姚佳雯 on 2019/10/2.
//  Copyright © 2019年 ywd. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    var itemArray = [Item]()
    
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
        
        print(dataFilePath!)
        loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row].title
        
//        if itemArray[indexPath.row].done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
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
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
//            do {
//                let encoder = PropertyListEncoder()
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to:self.dataFilePath!)
//            } catch {
//                print("编码错误:\(error)")
//            }
//
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField{(alertTextField) in
            
            alertTextField.placeholder = "创建一个新项目。。。"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
             print("编码错误:\(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
               print("解码错误:\(error)")
            }
        }
    }
}

