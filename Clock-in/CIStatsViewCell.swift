//
//  CIStatsViewCell.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIStatsViewCell: CITableViewCell {
    let infoLabel = UILabel()
    let dataLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clearColor()
        setupSubviews()
        constrainSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        infoLabel.font = UIFont.CIStatsInfoLabelFont()
        infoLabel.textColor = .whiteColor()
        infoLabel.numberOfLines = 1
        infoLabel.textAlignment = .Left
        infoLabel.text = "INFO LABEL"
        addSubview(infoLabel)
        
        dataLabel.font = UIFont.CIStatsDataLabelFont()
        dataLabel.textColor = .whiteColor()
        dataLabel.numberOfLines = 1
        dataLabel.textAlignment = .Center
        dataLabel.text = " "
        dataLabel.adjustsFontSizeToFitWidth = true
        dataLabel.minimumScaleFactor = 0.5
        addSubview(dataLabel)
    }
    
    func constrainSubviews() {
        infoLabel.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.top.equalTo(self.snp_top)
        }
        dataLabel.snp_makeConstraints{(make)->Void in
            make.leading.greaterThanOrEqualTo(self.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(self.snp_trailingMargin)
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(self.snp_bottom)
        }
    }
}