//
//  CIAddItemView.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIAddItemView: CIView {
    let backButton = UIButton()
    let titleLabel = UILabel()
    
    let addItemButton = CIButton(primaryColor: .CIBlue, title: "add item".localized)
    let globalStatsButton = CIButton(primaryColor: .CIGreen, title: "global stats".localized)
    let globalSettingsButton = CIButton(primaryColor: .CIGray, title: "settings".localized)
    
    let table = UITableView()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .CIBlue
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIErrorStrings.CoderInitUnimplemented)
    }
    
    func setupSubviews() {
        backButton.setTitle("‹go back", forState: .Normal)
        backButton.titleLabel!.font = UIFont.CIBackButtonFont
        backButton.setTitleColor(.whiteColor(), forState: .Normal)
        addSubview(backButton)
        
        titleLabel.text = "add item"
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
    }
    
    func constrainSubviews() {
        backButton.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop)
        }
        
        titleLabel.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.topMargin.equalTo(backButton.snp_bottom)
        }
    }
}