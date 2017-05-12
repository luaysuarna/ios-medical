//
//  PurchaseCell.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class PurchaseCell: UITableViewCell {
    
    @IBOutlet var viewWrapper: UIView!
    @IBOutlet var labelCashier: UILabel!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var labelItems: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
