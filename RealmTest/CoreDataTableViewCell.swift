//
//  CoreDataTableViewCell.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 05.05.2021.
//

import UIKit

class CoreDataTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let expireDateLabel = UILabel()
    private let offSet: CGFloat = 5
    
   override func layoutSubviews() {
        nameLabel.frame = CGRect(x: offSet, y: -offSet, width: self.frame.width*0.6 - offSet*4, height: self.frame.height-offSet*2)
        expireDateLabel.frame = CGRect(x: self.frame.width*0.6 + 2*offSet, y: -offSet, width: self.frame.width*0.4 - 4*offSet, height: self.frame.height-offSet*2)
        
        nameLabel.textAlignment = .left
        expireDateLabel.textAlignment = .center
        
        nameLabel.backgroundColor = .yellow
        expireDateLabel.backgroundColor = .blue
        self.addSubview(nameLabel)
        self.addSubview(expireDateLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
