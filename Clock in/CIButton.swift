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
            //if permanentHighlight, apply opposite style
            setStyle(permanentHighlight ? !highlighted : highlighted)
        }
    }
    
    var permanentHighlight: Bool {
        didSet {
            setStyle(permanentHighlight)
        }
    }
    
    required init(primaryColor: UIColor, title:String) {
        self.primaryColor = primaryColor
        self.permanentHighlight = false
        super.init(frame: CGRectZero)
        setTitle(title, forState: .Normal)
        setDefaultStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setDefaultStyle() {
        setTitleColor(primaryColor, forState: .Normal)
        titleLabel!.font = UIFont.CIButtonRegularFont
        titleLabel!.adjustsFontSizeToFitWidth = true
        titleLabel!.minimumScaleFactor = 0.8
        layer.borderColor = primaryColor.CGColor
        layer.borderWidth = 2.0
        layer.cornerRadius = CIConstants.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        titleEdgeInsets = CIButton.buttonInsets
    }
    
    func setStyle(highlighted: Bool) {
        if (highlighted) {
            setTitleColor(highlightedTitleColor(), forState: .Normal)
            backgroundColor = primaryColor
            titleLabel!.font = UIFont.CIButtonBoldFont
        }
        else {
            setTitleColor(primaryColor, forState: .Normal)
            backgroundColor = .clearColor()
            titleLabel!.font = UIFont.CIButtonRegularFont
        }
    }
    
    func highlightedTitleColor() -> UIColor? {
        if(self.superview == nil) { return nil }
        if(self.superview!.backgroundColor == nil) { return .whiteColor() }
        return self.superview!.backgroundColor
    }
}