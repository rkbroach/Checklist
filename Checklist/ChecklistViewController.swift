//
//  ViewController.swift
//  Checklist
//
//  Created by Rohan Kevin Broach on 6/14/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todolistObj: ToDoList
    
    private func priorityForSectionIndex(_ index: Int) -> ToDoList.Priority? {
        return ToDoList.Priority(rawValue: index)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let newRowIndex = todolistObj.todoList(for: .medium).count
        _ = todolistObj.newToDoItem()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section){
                    let todos = todolistObj.todoList(for: priority)

                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    todolistObj.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        todolistObj = ToDoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    // Number of Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todolistObj.todoList(for: priority).count
        }
        return 1
    }
    
    // Update TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todolistObj.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todolistObj.todoList(for: priority)
                let item = items[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todolistObj.todoList(for: priority)[indexPath.row]
            todolistObj.remove(item, from: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let sourcePriority = priorityForSectionIndex(sourceIndexPath.section), let destinationPriority = priorityForSectionIndex(destinationIndexPath.section){
            
            let item = todolistObj.todoList(for: sourcePriority)[sourceIndexPath.row]
            todolistObj.move(item: item, from: sourcePriority, at: sourceIndexPath.row, to: destinationPriority, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
    
    func configureText (for cell: UITableViewCell, with item: CheckListItem) {
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "✅"
        } else {
            checkmarkCell.checkmarkLabel.text = "⭕️"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = todolistObj
            }
        } else if segue.identifier == "EditItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                   let indexPath = tableView.indexPath(for: cell),
                   let priority = priorityForSectionIndex(indexPath.section)
                   {
                   let item = todolistObj.todoList(for: priority)[indexPath.row]
                   itemDetailViewController.itemToEdit = item
                   itemDetailViewController.delegate = self
                }
            }
        }
    }
    
    
    // Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ToDoList.Priority.allCases.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high :
                title = "High Priority"
            case .medium :
                title = "Medium Priority"
            case .low :
                title = "Low Priority"
            case .no :
                title = "Someday"
            }
        }
        return title
    }
    
    
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    
    
    
    
    // end of class
}


extension  ChecklistViewController: itemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todolistObj.todoList(for: .medium).count - 1
        let indexPaths = IndexPath(row: rowIndex, section: ToDoList.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPaths], with: .automatic)
    }
    
    func addItemViewControllr(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        
        for priority in ToDoList.Priority.allCases {
            let currentList = todolistObj.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

