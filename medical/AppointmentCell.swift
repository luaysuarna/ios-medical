//
//  AppointmentCell.swift
//  medical
//
//  Created by Luay Suarna on 3/13/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet var nameDoctor: UILabel!
    @IBOutlet var dateAppointment: UILabel!
    @IBOutlet var addressAppointment: UILabel!
    @IBOutlet var imageDoctor: UIImageView!
    @IBOutlet var imageStatus: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
