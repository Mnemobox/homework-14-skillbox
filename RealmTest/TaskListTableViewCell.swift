import UIKit

class TaskListTableViewCell: UITableViewCell {

    var taskListNamelabel = UILabel()
    var taskListDateLabel = UILabel()
    let offSet: CGFloat = 5
    let offSet2: CGFloat = 1
    
    
    override func layoutSubviews() {
        taskListNamelabel.frame = CGRect(x: offSet, y: offSet2, width: self.frame.width/2-2*offSet, height: self.frame.height-2*offSet2)
        taskListDateLabel.frame = CGRect(x: self.frame.width/2 + offSet, y: offSet2, width: self.frame.width/2-2*offSet, height: self.frame.height-2*offSet2)
        addSubview(taskListNamelabel)
        addSubview(taskListDateLabel)
        taskListDateLabel.numberOfLines = 0
        taskListDateLabel.font = UIFont(name: "Kailasa", size: 10)
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
