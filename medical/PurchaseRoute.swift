//
//  PurchaseRoute.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

enum PurchaseRoute: URLRequestConvertible {
    
    static let baseURLString = appConfig.API_ENDPOINT
    
    case list
    case create(date: String, totalPrice: String)
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/v1/purchase-header"
        case .create:
            return "/v1/purchase-header/create"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try AppointmentRoute.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .list:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .create(let date, let totalPrice):
            let parameters: Parameters = ["date": date, "total_price": totalPrice, "paid": totalPrice]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}

