//
//  CoreDataViewController.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 05.05.2021.
//

import UIKit
import CoreData

protocol CoreDataDelegate {
    func createNewTask(task: String, date: String)
}

class CoreDataViewController: UIViewController {

    var tasks:[NSManagedObject] = []
    
    private let toDoTableView = UITableView()
    
    func createTableView() {
        toDoTableView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(toDoTableView)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createTableView()
        toDoTableView.register(CoreDataTableViewCell.self, forCellReuseIdentifier: "coreCell")
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
       
        navigationItem.title = "Core Data To Do List"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        toDoTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addTask() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let addTaskViewController = storyboard.instantiateViewController(identifier: "addTask") as? AddTaskCoreDataViewController else { return }
        show(addTaskViewController, sender: nil)
        addTaskViewController.delegate = self
    }

    func saveNameAndDate(name: String, date: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manegedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoreTask", in: manegedContext)
        
        let task = NSManagedObject(entity: entity!, insertInto: manegedContext)
        
        task.setValue(name, forKey: "name")
        task.setValue(date, forKey: "expireDate")
        
        do {
            try manegedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print(error)
        }
       
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchedRequest: NSFetchRequest<CoreTask> = CoreTask.fetchRequest()
        
        do {
            tasks = try! managedContext.fetch(fetchedRequest)
            
        }
        
    }
}


extension CoreDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coreCell", for: indexPath) as! CoreDataTableViewCell
        
        let task = tasks[indexPath.row]
        cell.nameLabel.text = task.value(forKey: "name") as! String
        cell.expireDateLabel.text = task.value(forKey: "expireDate") as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (deleteAction, indexPath) in
            let rowToBeDeleted = self.tasks[indexPath.row]
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appdelegate?.persistentContainer.viewContext
            context?.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            do {
                try context?.save()
            } catch { let error = error as NSError
                print(error)
            }
            self.toDoTableView.reloadData()
        }
        return [deleteAction]
    }
}


extension CoreDataViewController: CoreDataDelegate {
    func createNewTask(task: String, date: String) {
        saveNameAndDate(name: task, date: date)
        toDoTableView.reloadData()
    }
    
    
}
