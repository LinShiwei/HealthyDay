//
//  DistanceDetailTableViewCell.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/13.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal class DistanceDetailTableViewCell: UITableViewCell {

    internal var date = Date(){
        didSet{
            dateLabel.text = getFormatDateDescription(fromDate: date)
        }
    }
    
    internal var distance : Double = 0{
        didSet{
            distanceLabel.text = String(format: "%.2f 公里", distance/1000.0)
        }
    }
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func getFormatDateDescription(fromDate date:Date)->String{
        let dateDescription = date.formatDescription()
        let timeRange = dateDescription.index(dateDescription.startIndex, offsetBy: 11)..<dateDescription.index(dateDescription.startIndex, offsetBy: 16)
        let dateArray = dateDescription.substring(to: dateDescription.index(dateDescription.startIndex, offsetBy: 10)).components(separatedBy: "-")
        
        let time = dateDescription.substring(with: timeRange)
        assert(dateArray.count == 3)
        return dateArray[1]+"月"+dateArray[2]+"日 "+time
    }
}
