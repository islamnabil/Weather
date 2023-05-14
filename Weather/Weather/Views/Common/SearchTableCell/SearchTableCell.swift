//
//  SearchTableCell.swift
//  Weather
//
//  Created by Islam Elgaafary on 14/05/2023.
//

import UIKit

class SearchTableCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
  
    //MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    //MARK: - Public Methods
    func config(query: String) {
        titleLabel.text = query
    }
    
}
