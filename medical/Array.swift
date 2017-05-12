//
//  Array.swift
//  medical
//
//  Created by Luay Suarna on 4/20/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation
extension Array {
    
    var first: T? {
        if isEmpty {
            return nil
        }
        
        return self[0]
    }
    
    var last: T? {
        if isEmpty {
            return nil
        }
        
        return self[count - 1]
    }
    
}
