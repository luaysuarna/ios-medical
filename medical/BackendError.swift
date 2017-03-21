//
//  BackendError.swift
//  medical
//
//  Created by Luay Suarna on 3/10/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}
