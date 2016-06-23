//
//  CIErrors.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

enum CIErrorType: ErrorType {
    case StringNotFoundError
    
}

extension CIErrorType : CustomStringConvertible {
    var description: String {
        switch self {
            case .StringNotFoundError:
                return "A required string was nil."
        }
    }
}

class CIError {
    static var CoderInitUnimplementedString = "Init(coder) called but not implemented."
}