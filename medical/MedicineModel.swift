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
    case Name = "name"
    case Quantity = "quantity"
    case UnitId = "unit_id"
    case Price = "price"
    case MedicineType = "type"
    case DateStock = "date_stock"
    case DateExpiration = "date_expiration"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
    case UnitName = "unit_name"
    case Unit = "unit"
    
}

class Medicine {
    
    var id: String?
    var name: String?
    var quantity: Double?
    var price: Double?
    var type: String?
    var dateStock: Date?
    var dateExpiration: Date?
    var unitId: String?
    var unitName: String?
    var unit: Unit?
    
    init(json: [String: Any]) {
        
        // Mark - String Type
        self.id = "\(json[MedicineFields.ID.rawValue] as! Int)"
        self.name = json[MedicineFields.Name.rawValue] as! String
        self.quantity = Double(json[MedicineFields.Quantity.rawValue] as! String)
        self.price = Double(json[MedicineFields.Price.rawValue] as! String)
        self.type = json[MedicineFields.MedicineType.rawValue] as! String
        self.unitId = "\(json[MedicineFields.UnitId.rawValue] as! Int)"
        self.unitName = json[MedicineFields.UnitName.rawValue] as! String
        
        // Mark - Date Type
        let dateFormatter = Patient.dateFormatter()
        
        if let dateString = json[MedicineFields.DateStock.rawValue] as? String {
            self.dateStock = dateFormatter.date(from: dateString)
        }
        if let dateString = json[MedicineFields.DateExpiration.rawValue] as? String {
            self.dateExpiration = dateFormatter.date(from: dateString)
        }
        
        // Mark - Unit Type
        if let jsonUnit = json[MedicineFields.Unit.rawValue] as? [String: Any] {
            self.unit = Unit(json: jsonUnit)
        }
    }
    
    /**
     * Mark - Rest Medicine
     **/
    
    fileprivate class func listRequest(completionHandler: @escaping (Result<MedicineWrapper>) -> Void) {
        
        let _ = Alamofire.request(MedicineRoute.list(limit: 100, page: 0))
            .responseJSON { response in
                
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Medicine.parseArrayResponse(response)
                completionHandler(result)
                
        }
    }
    
    /**
     * Mark - Public Rest Medicine
     **/
    
    class func list(_ completionHandler: @escaping (Result<MedicineWrapper>) -> Void) {
        listRequest(completionHandler: completionHandler)
    }
    
    /**
     * Retrieve Response
     **/
    
    private class func parseArrayResponse(_ response: DataResponse<Any>) -> Result<MedicineWrapper> {
        
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        guard let json = response.result.value as? [String: Any] else {
            print("Didn't get JSON")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON Dictionary in response"))
        }
        
        let wrapper: MedicineWrapper = MedicineWrapper()
        var allMedicine: [Medicine] = []
        
        wrapper.status = json["status"] as? Int
        wrapper.message = json["message"] as? String
        
        if let results = json["data"] as? [[String: Any]] {
            for jsonMedicine in results {
                
                let medicine = Medicine(json: jsonMedicine)
                allMedicine.append(medicine)
            }
        }
        
        wrapper.medicines = allMedicine
        return .success(wrapper)
        
    }
}
