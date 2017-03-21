//
//  SessionModel.swift
//  medical
//
//  Created by Luay Suarna on 3/2/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
import Security

// Constant identifier
let authToken: NSString = "AUTH_TOKEN"
let currentUser: String = "CURRENT_USER"

let userDefault = UserDefaults.standard

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class SessionModel: NSObject {
    
    /**
    * Exposed methods to perform load and save query
    **/
    
    public class func setAuthToken(_ token: NSString) {
        self.save(authToken, data: token)
    }
    
    public class func getAuthToken() -> NSString {
        let value = self.get(authToken)
        
        if value == nil {
            return ""
        } else {
            return value!
        }
    }
    
    public class func setCurrentUser(_ userObject: [String: Any]) {
        userDefault.set(userObject, forKey: currentUser)
    }
    
    public class func getCurrentUser() -> [String: Any] {
        return userDefault.object(forKey: currentUser) as! [String: Any]
    }
    
    /**
    * Internal methods
    **/
    
    private class func save(_ service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, authToken, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func get(_ service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, authToken, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}

enum CurrentUserFields: String {
    case ID = "id"
    case Name = "name"
    case Role = "role"
    case Token = "token"
}

class CurrentUser {
    
    var id: Int!
    var name: String?
    var role: String?
    var token: String?
    
    required init(_ json: [String: Any] ){
        self.id = json[CurrentUserFields.ID.rawValue] as? Int
        self.name = json[CurrentUserFields.Name.rawValue] as? String
        self.role = json[CurrentUserFields.Role.rawValue] as? String
        self.token = json[CurrentUserFields.Token.rawValue] as? String
    }
}
