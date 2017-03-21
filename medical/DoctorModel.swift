//
//  DoctorModel.swift
//  medical
//
//  Created by Luay Suarna on 3/9/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class DoctorWrapper {
    var status: Int?
    var doctors: [Doctor]?
}

enum DoctorFields: String {
    case ID = "id"
    case PersonId = "person_id"
    case RegNumber = "reg_number"
    case JoinedDate = "joined_date"
    case ResignDate = "resign_date"
    case Status = "status"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
    case Person = "person"
}

class Doctor {
    var id: String?
    var personId: String?
    var regNumber: String?
    var joinedDate: Date?
    var resignDate: Date?
    var status: String?
    var createdAt: Date?
    var updatedAt: Date?
    var person: Person?
    
    required init(json: [String: Any]) {
        
        // Strings
        self.id = json[DoctorFields.ID.rawValue] as? String
        self.personId = json[DoctorFields.PersonId.rawValue] as? String
        self.regNumber = json[DoctorFields.RegNumber.rawValue] as? String
        self.joinedDate = json[DoctorFields.JoinedDate.rawValue] as? Date
        self.resignDate = json[DoctorFields.ResignDate.rawValue] as? Date
        self.status = json[DoctorFields.Status.rawValue] as? String
        
        // Date
        let dateFormatter = Doctor.dateFormatter()
        if let dateString = json[DoctorFields.CreatedAt.rawValue] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json[DoctorFields.UpdatedAt.rawValue] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
        
        // Person
        if let personJson = json[DoctorFields.Person.rawValue] as? [String: Any] {
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
    
    /**
    * GET Rest - Retieve Doctors
    **/
    
    fileprivate class func getList(completionHandler: @escaping ((Result<DoctorWrapper>) -> Void) ) {
        let _ = Alamofire.request(DoctorRoute.index)
            .responseJSON { response in
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let doctorResults = Doctor.arrayFromResponse(response)
                completionHandler(doctorResults)
        }
    }
    
    
    /**
    * Publi Retrieve List
    **/
    class func list(_ completionHandler: @escaping (Result<DoctorWrapper>) -> Void) {
        getList(completionHandler: completionHandler)
    }
    
    /**
    * Retrieve Response
    **/
    
    private class func arrayFromResponse(_ response: DataResponse<Any>) -> Result<DoctorWrapper> {
        
        // got an error in getting the data
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        // make sure get JSON
        guard let json = response.result.value as? [String: Any] else {
            print("didn't get doctors as JSON from API")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let wrapper: DoctorWrapper = DoctorWrapper()
        wrapper.status = json["status"] as? Int
        
        var allDoctors: [Doctor] = []
        if let results = json["data"] as? [[String: Any]] {
            for jsonDoctors in results {
                let doctros = Doctor(json: jsonDoctors)
                allDoctors.append(doctros)
            }
        }
        wrapper.doctors = allDoctors
        return .success(wrapper)
    }
}
