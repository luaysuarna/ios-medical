//
//  AlertMessage.swift
//  medical
//
//  Created by Luay Suarna on 3/2/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit
import Foundation

class AlertMessage {
    func show(_ alertTitle: String, alertDescription: String) -> Void {
        
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title: alertTitle, message: alertDescription, delegate:nil, cancelButtonTitle: "OK")
        errorAlert.show()
    }
}
