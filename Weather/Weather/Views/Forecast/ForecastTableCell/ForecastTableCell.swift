//
//  ForecastTableCell.swift
//  Weather
//
//  Created by Islam Elgaafary on 13/05/2023.
//

import UIKit

class ForecastTableCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weathterConditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    //MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Public Methods
    func config(time: String, weatherCondition: String, temp: Double) {
        timeLabel.text = time.dateToString()
        weathterConditionLabel.text = weatherCondition
        tempLabel.text = "\(temp)"
    }
    
}
