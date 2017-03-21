//
//  PersonModel.swift
//  medical
//
//  Created by Luay Suarna on 3/9/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation

enum PersonFields: String {
    case ID = "id"
    case Name = "name"
    case Address = "address"
    case Email = "email"
    case Phone = "phone"
    case Gender = "gender"
    case BloodType = "blood_type"
    case DateOfBirth = "date_of_birth"
    case PlaceOfBirth = "place_of_birth"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
}

class Person {
    var id: String?
    var name: String?
    var address: String?
    var email: String?
    var phone: String?
    var gender: String?
    var bloodType: String?
    var dateOfBirth: Date?
    var placeOfBirth: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    required init(json: [String: Any]) {
        
        // String
        self.id = json[PersonFields.ID.rawValue] as? String
        self.name = json[PersonFields.Name.rawValue] as? String
        self.address = json[PersonFields.Address.rawValue] as? String
        self.email = json[PersonFields.Email.rawValue] as? String
        self.phone = json[PersonFields.Phone.rawValue] as? String
        self.gender = json[PersonFields.Gender.rawValue] as? String
        self.bloodType = json[PersonFields.BloodType.rawValue] as? String
        self.placeOfBirth = json[PersonFields.PlaceOfBirth.rawValue] as? String
        
        // Date
        let dateFormatter = Person.dateFormatter()
        if let date = json[PersonFields.DateOfBirth.rawValue] as? String {
            self.dateOfBirth = dateFormatter.date(from: date)
        }
        if let date = json[PersonFields.CreatedAt.rawValue] as? String {
            self.createdAt = dateFormatter.date(from: date)
        }
        if let date = json[PersonFields.UpdatedAt.rawValue] as? String {
            self.updatedAt = dateFormatter.date(from: date)
        }
    }
    
    class func dateFormatter() -> DateFormatter {
        // TODO: reuse date formatter, they're expensive!
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
}
