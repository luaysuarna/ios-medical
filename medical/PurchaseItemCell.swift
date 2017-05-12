//
//  PurchaseItemCell.swift
//  medical
//
//  Created by Luay Suarna on 3/30/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class PurchaseItemCell: UITableViewCell {
    
    @IBOutlet var labelMedicineType: UILabel!
    @IBOutlet var labelMedicineName: UILabel!
    @IBOutlet var labelMedicinePrice: UILabel!
    @IBOutlet var imageMedicine: UIImageView!
    @IBOutlet var labelMedicineCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
