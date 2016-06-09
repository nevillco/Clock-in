//
//  CIButton.swift
//  Clock in
//
//  Stylized UIButton used throughout application.
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIButton: UIButton {
    static let buttonInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    let primaryColor:UIColor
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                setTitleColor(highlightedTitleColor(), forState: .Highlighted)
                backgroundColor = primaryColor
                titleLabel!.font = UIFont.CIButtonBoldFont
            }
            else {
                setTitleColor(primaryColor, forState: .Highlighted)
                backgroundColor = .clearColor()
                titleLabel!.font = UIFont.CIButtonRegularFont
            }
        }
    }
    
    required init(primaryColor: UIColor, title:String) {
        self.primaryColor = primaryColor
        super.init(frame: CGRectZero)
        setTitle(title, forState: .Normal)
        setDefaultStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIErrorStrings.CoderInitUnimplemented)
    }
    
    func setDefaultStyle() {
        setTitleColor(primaryColor, forState: .Normal)
        titleLabel!.font = UIFont.CIButtonRegularFont
        layer.borderColor = primaryColor.CGColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 4.0
        translatesAutoresizingMaskIntoConstraints = false
        titleEdgeInsets = CIButton.buttonInsets
    }
    
    func highlightedTitleColor() -> UIColor? {
        if(self.superview == nil) { return nil }
        if(self.superview!.backgroundColor == nil) { return .whiteColor() }
        return self.superview!.backgroundColor
    }
}