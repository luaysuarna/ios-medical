//
//  MedicineModel.swift
//  medical
//
//  Created by Luay Suarna on 3/23/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class MedicineWrapper {
    
    var status: Int?
    var medicines: [Medicine]?
    var message: String?
    var totalData: Int?
    var currentPage: Int?
    var limitPage: Int?
    
}

enum MedicineFields: String {
    
    case ID = "id"
    case NAME = "name"
    case QUANTITY = "quantity"
    case PRICE = "price"
    case TYPE = "type"
    case DATE_STOCK = "date_stock"
    case DATE_EXPIRATION = "date_expiration"
    case UNIT_ID = "unit_id"
    case UNIT_NAME = "unit_name"
    
}

class Medicine {
    
    var id: String!
    var name: String!
    var quantity: Double!
    var price: Double!
    var type: String!
    var dateStock: Date!
    var dateExpiration: Date!
    var unitId: String!
    var unitName: String!
    
    init(json: [String: Any]) {
        
        // Mark - String Type
        self.id = json[MedicineFields.ID.rawValue] as! String
        self.name = json[MedicineFields.NAME.rawValue] as! String
        self.quantity = json[MedicineFields.QUANTITY.rawValue] as! Double
        self.price = json[MedicineFields.PRICE.rawValue] as! Double
        self.type = json[MedicineFields.TYPE.rawValue] as! String
        self.unitId = json[MedicineFields.UNIT_ID.rawValue] as! String
        self.unitName = json[MedicineFields.UNIT_NAME.rawValue] as! String
        
        // Mark - Date Type
        let dateFormatter = Patient.dateFormatter()
        
        if let dateString = json[MedicineFields.DATE_STOCK.rawValue] as? String {
            self.dateStock = dateFormatter.date(from: dateString)
        }
        if let dateString = json[MedicineFields.DATE_EXPIRATION.rawValue] as? String {
            self.dateExpiration = dateFormatter.date(from: dateString)
        }
    }
}
