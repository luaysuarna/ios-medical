//
//  PurchaseItemRoute.swift
//  medical
//
//  Created by Luay Suarna on 4/19/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

enum PurchaseItemRoute: URLRequestConvertible {
    
    static let baseURLString = appConfig.API_ENDPOINT
    
    case create(purchaseHeaderId: String, medicineId: String, quantity: String, unitId: String, price: String, totalPrice: String)
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/v1/purchase-detail/create"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try AppointmentRoute.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .create(let purchaseHeaderId, let medicineId, let quantity, let unitId, let price, let totalPrice):
            let parameters: Parameters = ["purchase_header_id": purchaseHeaderId, "medicine_id": medicineId, "quantity": quantity, "unit_id": unitId, "price": price, "total_price": totalPrice]
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
