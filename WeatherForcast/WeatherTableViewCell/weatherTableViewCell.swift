//
//  weatherTableViewCell.swift
//  WeatherForcast
//
//  Created by abishek m on 14/01/24.
//

import UIKit

class weatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
 
        }
    
    static let identifier = "weatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "weatherTableViewCell", bundle: nil)
    }
    
    
}
