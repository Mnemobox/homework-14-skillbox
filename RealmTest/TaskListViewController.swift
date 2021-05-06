import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
   
  
//    создаем таблицу, датасорс и реалм
    var tableView = UITableView()
   
    
    
    var dataTaskList = [TaskList]()
   
    func readTsksAndUpdate() {
        dataTaskList = uiRealm.objects(TaskList.self).map({ ($0)})
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readTsksAndUpdate()
    }
    func createTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(tableView)
        tableView.backgroundColor = .white
        
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        createTableView()
        dataTaskList = uiRealm.objects(TaskList.self).map({ ($0)})
       readTsksAndUpdate()
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createAlert))

        navigationItem.title = "To Do List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Core data version", style: .plain, target: self, action: #selector(goToCoreData))
//        navigationItem.leftBarButtonItem?.title = "Core Data Version"
        tableView.isUserInteractionEnabled = true
    }
    
    @objc func goToCoreData() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let coreDataController = storyboard.instantiateViewController(identifier: "coreData") as? CoreDataViewController else { return }
        show(coreDataController, sender: nil)
    }
    
    @objc func createAlert() {
        let alert = UIAlertController.init(title: "Новый список задач", message: "Добавить список задач", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [self] (action) in
            let newList = TaskList()
            let name = alert.textFields?.first?.text
            newList.name = name!
            newList.createdAt = NSDate()
               
               try! uiRealm.write { () -> Void in
                    uiRealm.add(newList)
            }
            self.readTsksAndUpdate()
           
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Введите название списка"
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
 
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataTaskList.count
        return dataTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskListTableViewCell
       
        cell.taskListNamelabel.text = dataTaskList[indexPath.row].name
        cell.taskListDateLabel.text = dataTaskList[indexPath.row].createdAt.description
        cell.layer.borderWidth = 1
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
            let rowTobeDeleted = self.dataTaskList[indexPath.row]
            try! uiRealm.write { () -> Void in
                uiRealm.delete(rowTobeDeleted)
                self.readTsksAndUpdate()
            }
        }
      
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
      
    }
    

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? TaskListTableViewCell {
                cell.taskListNamelabel.transform = .init(scaleX: 0.95, y: 0.95)
                cell.taskListDateLabel.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = .systemYellow
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? TaskListTableViewCell {
                cell.taskListNamelabel.transform = .identity
                cell.taskListDateLabel.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
    }
}


