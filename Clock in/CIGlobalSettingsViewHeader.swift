//
//  CIGlobalSettingsViewHeader.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIGlobalSettingsViewHeader: CIView {
    
    let label = UILabel()
    let addButton = CIButton(primaryColor: .whiteColor(), title: "add new")
    
    override init() {
        super.init()
        self.backgroundColor = .CIPurple
        self.layer.cornerRadius = CIConstants.cornerRadius
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
            make.width.equalTo(CIConstants.buttonWidth)
        }
    }
}