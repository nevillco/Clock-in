//
//  CISettingsViewHeader.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CISettingsViewHeader: CIView {
    
    let label = UILabel()
    let addButton = CIButton(primaryColor: .whiteColor(), title: "add new")
    
    override init() {
        super.init()
        self.backgroundColor = .CIGray
        self.layer.cornerRadius = CIConstants.cornerRadius()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = CIConstants.borderWidth()
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        label.text = "header"
        label.numberOfLines = 2
        addSubview(label)
        
        addSubview(addButton)
    }
    
    func constrainSubviews() {
        label.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.leading.equalTo(self.snp_leadingMargin)
        }
        
        addButton.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.width.equalTo(CIConstants.buttonWidth())
        }
    }
}