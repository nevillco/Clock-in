//
//  CIHomeView.swift
//  Clock in
//
//  View for home screen.
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIHomeView: UIView {
    
    let titleLabel = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(String.initCoderError())
    }
    
    func setupSubviews() {
        titleLabel.font = UIFont.CIHomeTitleLightFont()
        let titleText = "Clock:in"
        let definedText = "in"
        let attributedText = NSMutableAttributedString(string: titleText.localized)
        attributedText.addAttributes(
            [NSForegroundColorAttributeName: UIColor.CIBlue(),
                NSFontAttributeName: UIFont.CIHomeTitleBoldFont()], range: (titleText as NSString).rangeOfString(definedText))
        titleLabel.attributedText = attributedText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    func constrainSubviews() {
        titleLabel.snp_makeConstraints { (make)->Void in
            make.centerX.equalTo(self)
            make.topMargin.equalTo(self).offset(30)
        }
    }
}