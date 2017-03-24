//
//  MedicineRoute.swift
//  medical
//
//  Created by Luay Suarna on 3/23/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

enum MedicineRoute: URLRequestConvertible {
    
    static let baseURLString = appConfig.API_ENDPOINT
    
    case list(limit: Int, page: Int)
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/v1/medicine/list"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try AppointmentRoute.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .list(let limit, let page):
            let parameters: Parameters = ["id": limit, "page": page]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
