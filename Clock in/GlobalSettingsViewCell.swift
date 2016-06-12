//
//  GlobalSettingsViewCell.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIGlobalSettingsViewCell: CITableViewCell {
    
    let label = UILabel()
    let deleteButton = CIButton(primaryColor: .whiteColor(), title: "delete")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .CIGray
        setupSubviews()
        constrainSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        label.text = "interval"
        label.textColor = .whiteColor()
        label.font = UIFont.CIDefaultBodyFont
        addSubview(label)
        
        addSubview(deleteButton)
    }
    
    func constrainSubviews() {
        label.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.leading.equalTo(self.snp_leadingMargin)
        }
        
        deleteButton.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.width.equalTo(CIConstants.buttonWidth)
        }
    }
}