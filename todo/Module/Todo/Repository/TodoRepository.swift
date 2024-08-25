//
//  TodoRepository.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation
import CoreData

protocol TodoRepositoryProtocol {
    func fetchSavedData(completion: @escaping (Result<[TodoEntity], Error>) -> Void)
    func saveTodoList(_ todos: [TodoEntity])
    func addTodo(todoText: String, isCompleted: Bool, completion: @escaping () -> Void)
    func removeTodo(id: Int, completion: @escaping () -> Void)
    func editTodo(id: Int, todoText: String?, isCompleted: Bool?, completion: @escaping () -> Void)
}

class TodoRepository: TodoRepositoryProtocol {
    func fetchSavedData(completion: @escaping (Result<[TodoEntity], Error>) -> Void) {
        let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let tasks = try context.fetch(fetchRequest)
                let taskEntities = tasks.compactMap { task -> TodoEntity? in
                    if let creationDate = task.creationDate, let todo = task.todo {
                        return TodoEntity(id: Int(task.id), todo: todo, isCompleted: task.isCompleted, creationDate: creationDate)
                    }
                    return nil
                }
                
                DispatchQueue.main.async {
                    completion(.success(taskEntities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveTodoList(_ todos: [TodoEntity]) {
        let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            for (index, todo) in todos.enumerated() {
                let todoTask = TodoTask(context: context)
                todoTask.id = Int64(todo.id)
                todoTask.creationDate = todo.creationDate
                todoTask.isCompleted = todo.isCompleted
                todoTask.todo = todo.todo
                todoTask.order = Int16(index)
            }
            
            do {
                try context.save()
            } catch {
                // do nothing
            }
        }
    }
    
    func addTodo(todoText: String, isCompleted: Bool, completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                var ids = [Int64]()
                for task in tasks {
                    ids.append(task.id)
                    task.order += 1
                }
                
                let generateId: ([Int64]) -> Int64 = { existingIds in
                    guard let maxId = existingIds.max() else {
                        return 1
                    }
                    return maxId + 1
                }
                
                let todoTask = TodoTask(context: context)
                todoTask.id = generateId(ids)
                todoTask.creationDate = Date.now
                todoTask.isCompleted = isCompleted
                todoTask.todo = todoText
                todoTask.order = 0
                
                try context.save()
            } catch {
                // do nothing
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func removeTodo(id: Int, completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    context.delete(task)
                    
                    let fetchRemainingTasks: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
                    fetchRemainingTasks.predicate = NSPredicate(format: "order > %d", task.order)
                    
                    let remainingTasks = try context.fetch(fetchRemainingTasks)
                    for remainingTask in remainingTasks {
                        remainingTask.order -= 1
                    }
                    
                    try context.save()
                }
            } catch {
                // do nothing
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func editTodo(id: Int, todoText: String?, isCompleted: Bool?, completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    if let isCompleted = isCompleted {
                        task.isCompleted = isCompleted
                    }
                    
                    if let todo = todoText {
                        task.todo = todo
                    }
                    
                    try context.save()
                }
            } catch {
                // do nothing
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
