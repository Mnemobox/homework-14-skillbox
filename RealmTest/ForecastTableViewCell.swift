//
//  ForecastTableViewCell.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 28.04.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
  
    let nameLabel = UILabel()
    let dataLabel = UILabel()
    let dailyTempLabel = UILabel()
    let weatherImage = UIImageView()
    let offSet: CGFloat = 5
    
    
   

    override func layoutSubviews() {
        nameLabel.frame = CGRect(x: offSet, y: 0, width: self.frame.width*0.3, height: self.frame.height*0.4)
        dataLabel.frame = CGRect(x: offSet, y: offSet+self.frame.height*0.4, width: self.frame.width*0.5, height: self.frame.height*0.3)
        dailyTempLabel.frame = CGRect(x: self.frame.width-self.frame.width*0.3-offSet, y: self.frame.height/2 - self.frame.height*0.4, width: self.frame.width*0.3, height: self.frame.height*0.8)
        
        for v in [nameLabel, dailyTempLabel, dataLabel] {
            self.addSubview(v)
        }
        nameLabel.textAlignment = .left
        dataLabel.textAlignment = .left
        dailyTempLabel.textAlignment = .right
    
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
