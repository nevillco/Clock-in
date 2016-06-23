//
//  CITextField.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CITextField: UITextField {
    static let fieldInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    required init(placeholder:String) {
        super.init(frame: CGRectZero)
        setDefaultStyle(placeholder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setDefaultStyle(placeholder:String) {
        layer.borderWidth = CIConstants.borderWidth()
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = CIConstants.cornerRadius()
        font = UIFont.CITextFieldFont
        textColor = .whiteColor()
        clearButtonMode = .WhileEditing
        tintColor = .whiteColor()
        
        let textRange = NSRange(location: 0, length: placeholder.characters.count)
        let attributedText = NSMutableAttributedString(string: placeholder.localized)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor().colorWithAlphaComponent(0.4), range: textRange)
        attributedPlaceholder = attributedText
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y + 4, bounds.width - 28, bounds.height - 8)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return editingRectForBounds(bounds)
    }
}