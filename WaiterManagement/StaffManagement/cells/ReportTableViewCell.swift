//
//  ReportTableViewCell.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-15.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var afternoonLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
