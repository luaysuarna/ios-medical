//
//  PurchaseModel.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class PurchaseWrapper {
    var status: Int?
    var purchases: [Purchase]?
    var message: String?
    var purchase: Purchase?
}

enum PurchaseFields: String {
    case ID = "id"
    case Date = "date"
    case TotalPrice = "total_price"
    case Paid = "paid"
    case PurchaseDetails = "purchaseDetails"
}

class Purchase {
    
    var id: String?
    var date: Date?
    var totalPrice: Double?
    var paid: Double?
    var purchaseItems: [PurchaseItem] = []
    
    init(json: [String: Any]) {
        
        // Mark - String Type
        self.id = "\(json[PurchaseFields.ID.rawValue] as! Int)"
        
        // Mark - Double Type
        self.totalPrice = Double(json[PurchaseFields.TotalPrice.rawValue] as! String)
        self.paid = Double(json[PurchaseFields.Paid.rawValue] as! String)
        
        // Mark - Date Type
        let dateFormatter = Purchase.dateFormatter()

        if let dateString = json[PurchaseFields.Date.rawValue] as? String {
            self.date = dateFormatter.date(from: dateString)
        }
        
        // Mark - Items Type
        if let itemJson = json[PurchaseFields.PurchaseDetails.rawValue] as? [[String: Any]] {
            parseItemsJson(json: itemJson)
        }
    }
    
    class func dateFormatter() -> DateFormatter {
        // TODO: reuse date formatter, they're expensive!
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    func parseItemsJson(json: [[String: Any]]) {
        
        for jsonPurchaseItem in json {
            let purchaseItem = PurchaseItem(json: jsonPurchaseItem)
            self.purchaseItems.append(purchaseItem)
        }
    }
    
    /**
    * Mark - Rest Purchase
    **/
    
    fileprivate class func listRequest(completionHandler: @escaping (Result<PurchaseWrapper>) -> Void) {
        
        let _ = Alamofire.request(PurchaseRoute.list)
            .responseJSON { response in
                
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Purchase.parseArrayResponse(response)
                completionHandler(result)
                
        }
    }
    
    fileprivate class func createRequest(_ date: String, _ totalPrice: String, _ purchaseItems: [PurchaseItem], completionHandler: @escaping((Result<PurchaseWrapper>) -> Void)) {
        
        
        let _ = Alamofire.request(PurchaseRoute.create(date: date, totalPrice: totalPrice)).responseJSON {
            response in
            
            if let error = response.result.error {
                completionHandler(.failure(error))
                
                return
            }
            
            let result = Purchase.parseResponse(response)
            completionHandler(result)
        }
    }
    
    /**
    * Mark - Public Rest Purchase
    **/
    
    class func list(_ completionHandler: @escaping (Result<PurchaseWrapper>) -> Void) {
        listRequest(completionHandler: completionHandler)
    }
    
    class func create(_ date: String, _ totalPrice: String, _ purchaseItems: [PurchaseItem], _ completionHandler: @escaping (Result<PurchaseWrapper>) -> Void) {
        createRequest(date, totalPrice, purchaseItems, completionHandler: completionHandler)
    }
    
    /**
     * Retrieve Response
     **/
    
    private class func parseArrayResponse(_ response: DataResponse<Any>) -> Result<PurchaseWrapper> {
        
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        guard let json = response.result.value as? [String: Any] else {
            print("Didn't get JSON")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON Dictionary in response"))
        }
        
        let wrapper: PurchaseWrapper = PurchaseWrapper()
        var allPurchase: [Purchase] = []
        
        wrapper.status = json["status"] as? Int
        wrapper.message = json["message"] as? String
        
        if let results = json["data"] as? [[String: Any]] {
            for jsonPurchase in results {
                
                let purchase = Purchase(json: jsonPurchase)
                allPurchase.append(purchase)
            }
        }
        
        wrapper.purchases = allPurchase
        return .success(wrapper)
    }
    
    private class func parseResponse(_ response: DataResponse<Any>) -> Result<PurchaseWrapper> {

        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        guard let json =    response.result.value as? [String: Any] else {
            print("Didn't get JSON")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON Dictionary in response"))
        }
        
        let wrapper: PurchaseWrapper = PurchaseWrapper()
        wrapper.status = json["status"] as? Int
        var purchase: Purchase?
        
        if let result = json["data"] as? [String: Any] {
            purchase = Purchase(json: result)
        }
        wrapper.purchase = purchase
        
        return .success(wrapper)
    }
}
