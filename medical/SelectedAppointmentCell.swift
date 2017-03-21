//
//  SelectedAppointmentCell.swift
//  medical
//
//  Created by Luay Suarna on 3/15/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class SelectedAppointmentCell: UITableViewCell {
    
    @IBOutlet var labelText: UILabel!
    @IBOutlet var valueText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
