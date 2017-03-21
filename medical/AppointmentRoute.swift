//
//  SessionRoute.swift
//  medical
//
//  Created by Luay Suarna on 3/2/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

enum AppointmentRoute: URLRequestConvertible {
    
    case create(patientId: String, doctorId: String, date: String)
    case listByPatient(patientId: String)
    case listByDoctor(doctorId: String)
    case updateStatus(id: String, status: String)
    
    static let baseURLString = appConfig.API_ENDPOINT
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .listByPatient:
            return .get
        case .listByDoctor:
            return .get
        case .updateStatus:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/appointment/create"
        case .listByPatient:
            return "/appointment/find-by-patient"
        case .listByDoctor:
            return "/appointment/find-by-doctor"
        case .updateStatus:
            return "/appointment/status"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try AppointmentRoute.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .create(let patientId, let doctorId, let date):
            
            let parameters: Parameters = ["patient_id": patientId, "doctor_id": doctorId, "date": date, "status": "Pending"]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .listByPatient(let patientId):
            
            let parameters: Parameters = ["id": patientId]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .listByDoctor(let doctorId):
            
            let parameters: Parameters = ["id": doctorId]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateStatus(let id, let status):
            
            let newUrl = try (AppointmentRoute.baseURLString + "?id=\(id)").asURL()
            var newUrlRequest = URLRequest(url: newUrl.appendingPathComponent(path))
            newUrlRequest.httpMethod = method.rawValue
            
            let parameters: Parameters = ["status": status]
            urlRequest = try URLEncoding.default.encode(newUrlRequest, with: parameters)
            
        default:
            break
        }
        
        return urlRequest
    }
}
