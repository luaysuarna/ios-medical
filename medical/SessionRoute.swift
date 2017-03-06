//
//  SessionRoute.swift
//  medical
//
//  Created by Luay Suarna on 3/2/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

let appConfig = AppConfig()

enum SessionRoute: URLRequestConvertible {
    
    case login(email: String, password: String)
    static let baseURLString = appConfig.API_ENDPOINT
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user-login/login"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try SessionRoute.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .login(let email, let password):
            let parameters: Parameters = ["username": email, "password": password]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
