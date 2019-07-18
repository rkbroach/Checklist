//
//  ToDoList.swift
//  Checklist
//
//  Created by Rohan Kevin Broach on 6/24/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import Foundation

//MODEL
class ToDoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos = [CheckListItem]()
    private var mediumPriorityTodos = [CheckListItem]()
    private var lowPriorityTodos = [CheckListItem]()
    private var noPriorityTodos = [CheckListItem]()
    
    //var todos: [CheckListItem] = []
    
    init() {
        let row0item = CheckListItem()
        let row1item = CheckListItem()
        let row2item = CheckListItem()
        let row3item = CheckListItem()
        let row4item = CheckListItem()
        let row5item = CheckListItem()
        let row6item = CheckListItem()
        let row7item = CheckListItem()
        let row8item = CheckListItem()
        let row9item = CheckListItem()
        
        row0item.text = "Exercise"
        row1item.text = "Watch a movie"
        row2item.text = "Code an app"
        row3item.text = "Sleep on time"
        row4item.text = "Study"
        row5item.text = "Prepare report"
        row6item.text = "Learn to draw"
        row7item.text = "Buy groceries"
        row8item.text = "Schedule photoshoot"
        row9item.text = "Buy a PC"
        
        addTodo(row0item, for: .medium)
        addTodo(row1item, for: .low)
        addTodo(row2item, for: .medium)
        addTodo(row3item, for: .high)
        addTodo(row4item, for: .no)
        addTodo(row5item, for: .high)
        addTodo(row6item, for: .medium)
        addTodo(row7item, for: .low)
        addTodo(row8item, for: .high)
        addTodo(row9item, for: .medium)
    }
    
    func todoList (for priority: Priority) -> [CheckListItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func newToDoItem () -> CheckListItem {
        let item = CheckListItem()
        item.text = randomTitle()
        mediumPriorityTodos.append(item)
        return item
    }
    
    func addTodo(_ item: CheckListItem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
        }
    }
    
    func move(item: CheckListItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
    }
    
    func remove (_ item: CheckListItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }   
    
    private func randomTitle() -> String {
        var titles = ["New To Do item", "Generic To Do", "Fill me out", "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
}
