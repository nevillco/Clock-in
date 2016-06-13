//
//  CIItemSettingsView.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIItemSettingsView: CIView {
    
    let itemName:String
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let notificationsLabel = UILabel()
    let table = UITableView()
    let bottomContainer = CIView()
    let renameButton = CIButton(primaryColor: .whiteColor(), title: "rename".localized)
    let deleteButton = CIButton(primaryColor: .whiteColor(), title: "delete".localized)
    
    required init(name:String) {
        self.itemName = name
        super.init()
        backgroundColor = .CIGray
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        backButton.setTitle("‹go back".localized, forState: .Normal)
        backButton.titleLabel!.font = UIFont.CILargeTextButtonFont
        backButton.setTitleColor(.whiteColor(), forState: .Normal)
        backButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(backButton)
        
        titleLabel.text = itemName
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        addSubview(titleLabel)
        
        notificationsLabel.text = "If you want, you can have an item send notifications after certain amounts of time. You can also change notifications on specific items by going to their settings.".localized
        notificationsLabel.font = UIFont.CIDefaultBodyFont
        notificationsLabel.textColor = .whiteColor()
        notificationsLabel.numberOfLines = 0
        addSubview(notificationsLabel)
        
        table.separatorStyle = .None
        table.allowsSelection = false
        table.backgroundColor = .clearColor()
        addSubview(table)
        
        bottomContainer.backgroundColor = .CIRed
        addSubview(bottomContainer)
        
        bottomContainer.addSubview(renameButton)
        bottomContainer.addSubview(deleteButton)
    }
    
    func constrainSubviews() {
        backButton.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.baseline.equalTo(titleLabel.snp_baseline)
        }
        
        titleLabel.snp_makeConstraints {(make)->Void in
            make.leading.greaterThanOrEqualTo(backButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop)
        }
        
        notificationsLabel.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
        }
        
        table.snp_makeConstraints {(make)->Void in
            make.top.equalTo(notificationsLabel.snp_bottom).offset(2 * CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(deleteButton.snp_top).offset(-CIConstants.verticalItemSpacing)
        }
        
        bottomContainer.snp_makeConstraints{(make)->Void in
            make.top.equalTo(renameButton.snp_top).offset(-2 * CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        renameButton.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(bottomContainer.snp_centerX).offset(-0.5 * CIConstants.verticalItemSpacing)
            make.bottom.equalTo(bottomContainer.snp_bottom).offset(-2 * CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        deleteButton.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(bottomContainer.snp_centerX).offset(0.5 * CIConstants.verticalItemSpacing)
            make.bottom.equalTo(bottomContainer.snp_bottom).offset(-2 * CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
    }
}