//
//  CIStrings.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation

extension String {
    var localized: String { return NSLocalizedString(self, comment: "") }
    
    static func initCoderError() -> String { return "Error: init (coder) called but not implemented." }
}
