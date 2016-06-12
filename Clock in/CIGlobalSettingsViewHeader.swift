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
    let topLine = UIView()
    let bottomLine = UIView()
    
    override init() {
        super.init()
        self.backgroundColor = .CIGray
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        label.text = "header"
        label.textColor = .whiteColor()
        label.font = UIFont.CIDefaultBodyFont
        label.numberOfLines = 2
        addSubview(label)
        
        addSubview(addButton)
        
        topLine.backgroundColor = .whiteColor()
        addSubview(topLine)
        
        bottomLine.backgroundColor = .whiteColor()
        addSubview(bottomLine)
    }
    
    func constrainSubviews() {
        label.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.leading.equalTo(self.snp_leading)
        }
        
        addButton.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.trailing.equalTo(self.snp_trailing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        topLine.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
        
        bottomLine.snp_makeConstraints{(make)->Void in
            make.bottom.equalTo(self.snp_bottom)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
    }
}