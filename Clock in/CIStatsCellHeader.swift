//
//  CIStatsCellHeader.swift
//  Clock in
//
//  Created by Connor Neville on 6/16/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import UIKit

class CIStatsCellHeader: CIView {
    let label = UILabel()
    let botLine = UIView()
    
    required init(color: UIColor) {
        super.init()
        self.backgroundColor = color
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        label.textColor = .whiteColor()
        label.font = UIFont.CIStatsHeaderFont
        label.textAlignment = .Center
        addSubview(label)
        
        botLine.backgroundColor = .whiteColor()
        addSubview(botLine)
    }
    
    func constrainSubviews() {
        label.snp_makeConstraints{(make)->Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX)
        }
        
        botLine.snp_makeConstraints{(make)->Void in
            make.bottom.equalTo(self.snp_bottom)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
    }
}