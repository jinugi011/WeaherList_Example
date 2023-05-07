//
//  WeatherCell.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/05.
//

import UIKit

class WeatherCell: UITableViewCell {

    
    @IBOutlet weak var titleDay : UILabel!
    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var tmpLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
