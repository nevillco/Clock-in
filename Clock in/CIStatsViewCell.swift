//
//  CIStatsViewCell.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIStatsViewCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = CIConstants.borderWidth
        self.layer.cornerRadius = CIConstants.cornerRadius
        
        label.text = "cell"
        label.textColor = .whiteColor()
        label.font = UIFont.CIButtonRegularFont
        translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }
    
    func constrainSubviews() {
        label.snp_makeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.centerY.equalTo(self.snp_centerY)
        }
    }
}