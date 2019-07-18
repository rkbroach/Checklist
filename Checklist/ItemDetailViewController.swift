//
//  AddItemTableTableViewController.swift
//  Checklist
//
//  Created by Rohan Kevin Broach on 6/24/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit

protocol itemDetailViewControllerDelegate : class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
  func addItemViewControllr(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem)
}


class ItemDetailViewController: UITableViewController {
  
  weak var delegate: itemDetailViewControllerDelegate?
  weak var todoList: ToDoList?
  weak var itemToAdd: CheckListItem?
  weak var itemToEdit: CheckListItem?
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var textField: UITextField!
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {
    
    if let item = itemToEdit, let text = textField.text {
      item.text = text
      delegate?.addItemViewControllr(self, didFinishEditing: item)
    }
      
    else {
      if let item = todoList?.newToDoItem() {
        if let textFieldText = textField.text {
          item.text = textFieldText
        }
        item.checked = false
        delegate?.itemDetailViewController(self, didFinishAdding: item)
        
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit"
      textField.text = item.text
      addButton.isEnabled = true
    }
    textField.delegate = self
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func viewWillAppear(_ animated: Bool) {
    textField.becomeFirstResponder()
   
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

extension ItemDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = textField.text,
          let stringRange = Range(range, in: oldText) else {
          return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    if newText.isEmpty {
      addButton.isEnabled = false
    } else {
      addButton.isEnabled = true
    }
    return true
  }
  
  
}
