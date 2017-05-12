//
//  UnitModel.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation

enum UnitFields: String {
    
    case ID = "id"
    case Name = "name"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
    
}

class Unit {
    
    var id: String?
    var name: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(json: [String: Any]) {
        
        // Mark - String
        self.id = json[UnitFields.ID.rawValue] as! String
        self.name = json[UnitFields.Name.rawValue] as! String
        
        // Mark - Date
        let dateFormatter = Patient.dateFormatter()
        
        if let dateString = json[UnitFields.CreatedAt.rawValue] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json[UnitFields.CreatedAt.rawValue] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
        
    }
}
