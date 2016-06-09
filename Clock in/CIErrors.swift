//
//  CIErrors.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

enum CIError: ErrorType {
    case SomeError
}

extension CIError : CustomStringConvertible {
    var description: String {
        switch self {
            case .SomeError:
                return "SomeError description"
        }
    }
}

class CIErrorStrings {
    static var CoderInitUnimplemented = "Init(coder) called but not implemented."
}