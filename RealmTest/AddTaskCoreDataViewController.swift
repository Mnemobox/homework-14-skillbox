//
//  AddTaskCoreDataViewController.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 05.05.2021.
//

import UIKit

class AddTaskCoreDataViewController: UIViewController {

    var delegate: CoreDataDelegate?
    
    private let taskTextfield = UITextField()
    private let dataPicker = UIDatePicker()
    private let label = UILabel()
    private let saveButton = UIButton()
    
    var dateFromPicker: String?
    
    
    func setTextAndPicker() {
        taskTextfield.frame = CGRect(x: UIScreen.main.bounds.width/2 - UIScreen.main.bounds.width*0.4, y: UIScreen.main.bounds.height*0.3, width: UIScreen.main.bounds.width*0.8, height: 50)
        dataPicker.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height*0.4, width: 300, height: UIScreen.main.bounds.height*0.6)
        label.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height*0.65, width: 300, height: 50)
        saveButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height*0.2, width: 150, height: 50)
        
        saveButton.setTitle("Готово", for: .normal)
        saveButton.backgroundColor = .systemGreen
        
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        label.text = "Срок выполнения"
        label.font = UIFont(name: "AmericanTypeWriter", size: 25)
        label.textColor = .systemGreen
        label.textAlignment = .center
        
        taskTextfield.backgroundColor = .white
        taskTextfield.alpha = 0.8
        taskTextfield.adjustsFontSizeToFitWidth = true
        taskTextfield.tintColor = .white
        taskTextfield.textColor = .black
        taskTextfield.font = UIFont(name: "AmericanTypeWriter", size: 30)
        
        
        taskTextfield.placeholder = "Введите название задачи"
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.addTarget(self, action: #selector(newDate), for: .valueChanged)
        
        view.addSubview(taskTextfield)
        view.addSubview(dataPicker)
        view.addSubview(label)
        view.addSubview(saveButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTextAndPicker()
        

        // Do any additional setup after loading the view.
    }
    
    @objc func saveTask() {
       
        delegate?.createNewTask(task: taskTextfield.text ?? "", date: dateFromPicker ?? dataPicker.date.description)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newDate() {
        var timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        dateFromPicker = timeFormatter.string(from: dataPicker.date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
