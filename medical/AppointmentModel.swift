//
//  AppointmentModel.swift
//  medical
//
//  Created by Luay Suarna on 3/10/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Alamofire

class AppointmentWrapper {
    var status: Int?
    var appointments: [Appointment]?
    var appointment: Appointment?
}

enum AppointmentFields: String {
    case Date = "date"
    case DoctorId = "doctor_id"
    case PatientId = "patient_id"
    case Status = "status"
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
    case ID = "id"
    case Doctor = "doctor"
    case Patient = "patient"
}

class Appointment {
    var date: Date?
    var doctorId: String?
    var patientId: String?
    var status: String?
    var createdAt: Date?
    var updatedAt: Date?
    var id: String?
    var doctor: Doctor?
    var patient: Patient?
    
    required init(json: [String: Any]) {
        
        // Strings
        self.doctorId = json[AppointmentFields.DoctorId.rawValue] as? String
        self.patientId = json[AppointmentFields.PatientId.rawValue] as? String
        self.status = json[AppointmentFields.Status.rawValue] as? String
        self.id = json[AppointmentFields.ID.rawValue] as? String
        
        // Date
        let dateFormatter = Appointment.dateFormatter()
        if let dateString = json[AppointmentFields.Date.rawValue] as? String {
            self.date = Utils.stringToDate(dateString)
        }
        if let dateString = json[AppointmentFields.CreatedAt.rawValue] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json[AppointmentFields.UpdatedAt.rawValue] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
        
        // Object
        if let doctorJson = json[AppointmentFields.Doctor.rawValue] as? [String : Any] {
            self.doctor = Doctor(json: doctorJson)
        }
        if let patientJson = json[AppointmentFields.Patient.rawValue] as? [String : Any] {
            self.patient = Patient(json: patientJson)
        }
    }
    
    class func dateFormatter() -> DateFormatter {
        // TODO: reuse date formatter, they're expensive!
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return aDateFormatter
    }
    
    /**
     * GET Rest - Retieve Doctors
     **/
    
    fileprivate class func createRequest(_ patientId: String, _ doctorId: String, _ date: String, completionHandler: @escaping ((Result<AppointmentWrapper>) -> Void) ) {
        let _ = Alamofire.request(AppointmentRoute.create(patientId: patientId, doctorId: doctorId, date: date))
            .responseJSON { response in
                
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Appointment.parseResponse(response)
                completionHandler(result)
        }
    }
    
    fileprivate class func listRequestByPatient(patientId: String, status: String, completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        let _ = Alamofire.request(AppointmentRoute.listByPatient(patientId: patientId, status: status))
            .responseJSON { response in
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Appointment.parseResponseArray(response)
                completionHandler(result)
        }
    }
    
    
    fileprivate class func listRequestByDoctor(doctorId: String, status: String, completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        
        let _ = Alamofire.request(AppointmentRoute.listByDoctor(doctorId: doctorId, status: status))
            .responseJSON { response in
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Appointment.parseResponseArray(response)
                completionHandler(result)
        }
    }
    
    fileprivate class func updateStatusRequest(_ id: String, status: String, completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        
        let parameters: Parameters = ["status": "Approved"]
        // Alamofire.request(route)
        let _ = Alamofire.request(AppointmentRoute.updateStatus(id: id, status: status))
            .responseJSON { response in
                
                if let error = response.result.error {
                    completionHandler(.failure(error))
                    return
                }
                
                let result = Appointment.parseResponse(response)
                completionHandler(result)
        }
    }
    
    /**
     * Public Retrieve List
     **/
    
    class func create(patientId: String, doctorId: String, date: String, completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        createRequest(patientId,doctorId, date, completionHandler: completionHandler)
    }
    
    class func listByPatient(patientId: String, status: String, _ completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        listRequestByPatient(patientId: patientId, status: status, completionHandler: completionHandler)
    }
    
    class func listByDoctor(doctorId: String, status: String, _ completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        listRequestByDoctor(doctorId: doctorId, status: status, completionHandler: completionHandler)
    }
    
    class func updateStatus(id: String, status: String, _ completionHandler: @escaping (Result<AppointmentWrapper>) -> Void) {
        updateStatusRequest(id, status: status, completionHandler: completionHandler)
    }
    
    /**
     * Retrieve Response
     **/
    
    private class func parseResponse(_ response: DataResponse<Any>) -> Result<AppointmentWrapper> {
        
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
        
        // make sure data stored
        guard (json["status"] as? Bool)! else {
            print(json["message"] as? String)
            return .failure(BackendError.objectSerialization(reason: (json["message"] as? String)!))
        }
        
        let wrapper: AppointmentWrapper = AppointmentWrapper()
        wrapper.status = json["status"] as? Int
        
        var appointment: Appointment?
        
        if let result = json["data"] as? [String: Any] {
            appointment = Appointment(json: result)
        }
        wrapper.appointment = appointment
        return .success(wrapper)
    }
    
    private class func parseResponseArray(_ response: DataResponse<Any>) -> Result<AppointmentWrapper> {
        
        // got an error in getting the data
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        // make sure get JSON
        guard let json = response.result.value as? [String: Any] else {
            print("didn't get appointments as JSON from API")
            return .failure(BackendError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let wrapper: AppointmentWrapper = AppointmentWrapper()
        wrapper.status = json["status"] as? Int
        
        var allAppointment: [Appointment] = []
        if let results = json["data"] as? [[String: Any]] {
            for jsonAppointment in results {
                let appointment = Appointment(json: jsonAppointment)
                allAppointment.append(appointment)
            }
        }
        wrapper.appointments = allAppointment
        return .success(wrapper)

    }
}
