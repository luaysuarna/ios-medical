//
//  CashierCell.swift
//  medical
//
//  Created by Luay Suarna on 4/6/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class CashierCell: UITableViewCell {
    
    @IBOutlet var labelMedicineType: UILabel!
    @IBOutlet var labelMedicineName: UILabel!
    @IBOutlet var labelMedicinePrice: UILabel!
    @IBOutlet var imageMedicine: UIImageView!
    @IBOutlet var labelMedicineCount: UILabel!
    @IBOutlet var btnAddItem: UIButton!
    @IBOutlet var btnReduceItem: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
