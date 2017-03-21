//
//  PatientModel.swift
//  medical
//
//  Created by Luay Suarna on 3/13/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class PatientWrapper {
    var status: Int?
    var patients: [Patient]?
}

enum PatientFields: String {
    case ID = "id"
    case PersonId = "person_id"
    case PatientNumber = "patient_number"
    case RegisteredDate = "registered_date"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
    case Person = "person"
}

class Patient {
    var id: String?
    var personId: String?
    var patientNumber: String?
    var registeredDate: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var person: Person?
    
    required init(json: [String: Any]) {
        
        // Strings
        self.id = json[PatientFields.ID.rawValue] as? String
        self.personId = json[PatientFields.PersonId.rawValue] as? String
        self.patientNumber = json[PatientFields.PatientNumber.rawValue] as? String
        
        // Date
        let dateFormatter = Patient.dateFormatter()
        if let dateString = json[PatientFields.CreatedAt.rawValue] as? String {
            self.registeredDate = dateFormatter.date(from: dateString)
        }
        if let dateString = json[PatientFields.CreatedAt.rawValue] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json[PatientFields.UpdatedAt.rawValue] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
        
        // Person
        if let personJson = json[PatientFields.Person.rawValue] as? [String: Any] {
            self.person = Person(json: personJson)
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

