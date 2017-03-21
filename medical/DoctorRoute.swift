//
//  DoctorRoute.swift
//  medical
//
//  Created by Luay Suarna on 3/9/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

enum DoctorRoute: URLRequestConvertible {
    
    case index
    static let baseURLString = appConfig.API_ENDPOINT
    
    var method: HTTPMethod {
        switch self {
        case .index:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .index:
            return "/doctor"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try DoctorRoute.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .index:
            let parameters: Parameters? = nil
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
