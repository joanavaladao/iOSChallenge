//
//  TwoButtonsTableViewCell.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-15.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class TwoButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
