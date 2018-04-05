//
//  BalanceCell.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 4/4/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class BalanceCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountLabel.text = "awaking"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackgroundColor(_ color:UIColor){
        self.backgroundColor = color
    }

}
