//
//  PurchaseItemModel.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class PurchaseItemWrapper {
    var status: Int?
    var purchaseItem: PurchaseItem?
    var message: String?
}

enum PurchaseItemFields: String {
    
    case ID = "id"
    case PurchaseHeaderId = "purchase_header_id"
    case Quantity = "quantity"
    case Price = "price"
    case TotalPrice = "total_price"
    case MedicineId = "medicine_id"
    case UnitId = "unit_id"
    case MedicineName = "medicine_name"
    case UnitName = "unit_name"
    
}

class PurchaseItem {
    
    var id: String?
    var purchaseHeaderId: String?
    var quantity: Double?
    var price: Double?
    var totalPrice: Double?
    var medicineId: String?
    var unitId: String?
    var medicineName: String?
    var unitName: String?
    
    init(json: [String: Any]) {
        
        // Mark - String Type
        if let id = json[PurchaseItemFields.ID.rawValue] as? Int {
            self.id = "\(id)"
        }
        if let purchaseHeaderId = json[PurchaseItemFields.PurchaseHeaderId.rawValue] as? Int {
            self.purchaseHeaderId = "\(purchaseHeaderId)"
        }
        if let medicineId = json[PurchaseItemFields.MedicineId.rawValue] as? Int {
            self.medicineId = "\(medicineId)"
        }
        self.medicineName = json[PurchaseItemFields.MedicineName.rawValue] as! String
        if let unitId = json[PurchaseItemFields.UnitId.rawValue] as? Int {
            self.unitId = "\(unitId)"
        }
        self.unitName = json[PurchaseItemFields.UnitName.rawValue] as! String
        
        // Mark - Double Type
        self.quantity = Double(json[PurchaseItemFields.Quantity.rawValue] as! String)
        self.price = Double(json[PurchaseItemFields.Price.rawValue] as! String)
        self.totalPrice = Double(json[PurchaseItemFields.TotalPrice.rawValue] as! String)
    }
    
    /**
     * Mark - Rest Purchase Item
     **/
        
    fileprivate class func createItemRequest(_ purchaseHeaderId: String, medicineId: String, quantity: String, unitId: String, price: String, totalPrice: String, completionHandler: @escaping((Result<PurchaseItemWrapper>) -> Void)) {
        
        let _ = Alamofire.request(PurchaseItemRoute.create(purchaseHeaderId: purchaseHeaderId, medicineId: medicineId, quantity: quantity, unitId: unitId, price: price, totalPrice: totalPrice)).responseJSON {
            response in
            
            if let error = response.result.error {
                completionHandler(.failure(error))
                
                return
            }
            
            let result = PurchaseItem.parseResponse(response)
            completionHandler(result)
        }
    }
    
    /**
     * Mark - Rest Purchase Item
     **/
    
    class func createItem(_ pucrhaseHeaderId: String, medicineId: String, quantity: String, unitId: String, price: String, totalPrice: String, completionHandler: @escaping((Result<PurchaseItemWrapper>) -> Void)) {
        createItemRequest(pucrhaseHeaderId, medicineId: medicineId, quantity: quantity, unitId: unitId, price: price, totalPrice: totalPrice, completionHandler: completionHandler)
    }
    
    /**
     * Mark - Retrieve Data
     **/
    
    class func parseResponse(_ response: DataResponse<Any>) -> Result<PurchaseItemWrapper> {
        
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        guard let json = response.result.value as? [String: Any] else {
            print("Didn't get JSON")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON Dictionary in response"))
        }
        
        let wrapper: PurchaseItemWrapper = PurchaseItemWrapper()
        wrapper.status = json["status"] as? Int
        var purchaseItem: PurchaseItem?
        
        if let result = json["data"] as? [String: Any] {
            purchaseItem = PurchaseItem(json: result)
        }
        wrapper.purchaseItem = purchaseItem
        
        return .success(wrapper)
    }

}
