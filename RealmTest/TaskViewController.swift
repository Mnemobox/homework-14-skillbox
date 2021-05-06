//
//  TaskViewController.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 24.04.2021.
//

import UIKit


class TaskViewController: UIViewController {
// thats not task view controller any more, but I decided not to recall it in order not to break it all down
//    thats textfields view controller
 
 let nameTextfield = UITextField()
    let secondNameTextfield = UITextField()
    
    let nameWidth: CGFloat = 200
    let nameHeight: CGFloat = 50
    
    func createTextfields() {
        nameTextfield.frame = CGRect(x: view.frame.width/2-nameWidth/2, y: view.frame.height*0.2, width: nameWidth, height: nameHeight)
        
        secondNameTextfield.frame = CGRect(x: view.frame.width/2-nameWidth/2, y: view.frame.height*0.4, width: nameWidth, height: nameHeight)
        
        view.addSubview(nameTextfield)
        view.addSubview(secondNameTextfield)
        
        nameTextfield.backgroundColor = .secondarySystemFill
        secondNameTextfield.backgroundColor = .secondarySystemFill
        
        nameTextfield.placeholder = "Введите имя"
        secondNameTextfield.placeholder = "Введите фамилию"
        
        nameTextfield.layer.cornerRadius = 10
        secondNameTextfield.layer.cornerRadius = 10
        
        nameTextfield.addTarget(self, action: #selector(updateName), for: .allEditingEvents)
        secondNameTextfield.addTarget(self, action: #selector(updateSecondName), for: .allEditingEvents)
        
        if Persistance.shared.userName != nil {
            nameTextfield.placeholder = Persistance.shared.userName
        }
        if Persistance.shared.secondUserName != nil {
            secondNameTextfield.placeholder = Persistance.shared.secondUserName
        }
        
        if Persistance.shared.userName == "" {
            nameTextfield.placeholder = "Введите имя"
        }
        if Persistance.shared.secondUserName == "" {
            secondNameTextfield.placeholder = "Введите фамилию"
        }
    }
    
    @objc func updateName() {
        Persistance.shared.userName = nameTextfield.text

    }
    @objc func updateSecondName() {
        Persistance.shared.secondUserName = secondNameTextfield.text
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createTextfields()
      
        view.backgroundColor = .white
    }
    
    
}
