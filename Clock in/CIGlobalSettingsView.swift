//
//  CIGlobalSettingsView.swift
//  Clock in
//
//  Created by Connor Neville on 6/11/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIGlobalSettingsView: CIView {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let notificationsButton = CIButton(primaryColor: .whiteColor(), title: "notifications on".localized)
    let notificationsLabel = UILabel()
    let table = UITableView()
    let deleteLabel = UILabel()
    let deleteButton = CIButton(primaryColor: .CIRed, title: "delete all".localized)
    
    override init() {
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
        backButton.titleLabel!.font = UIFont.CIBackButtonFont
        backButton.setTitleColor(.whiteColor(), forState: .Normal)
        backButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(backButton)
        
        titleLabel.text = "settings".localized
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        addSubview(notificationsButton)
        
        notificationsLabel.text = "If you want, you can have an item send notifications after certain amounts of time. You can also change notifications on specific items by going to their settings.".localized
        notificationsLabel.font = UIFont.CIDefaultBodyFont
        notificationsLabel.textColor = .whiteColor()
        notificationsLabel.numberOfLines = 0
        addSubview(notificationsLabel)
        
        table.separatorStyle = .None
        table.allowsSelection = false
        table.backgroundColor = .clearColor()
        addSubview(table)
        
        deleteLabel.text = "Tap the button to the right to delete all of your items. Be careful, there is no undo.".localized
        deleteLabel.font = UIFont.CIDefaultBodyFont
        deleteLabel.textColor = .whiteColor()
        deleteLabel.numberOfLines = 0
        addSubview(deleteLabel)
        
        addSubview(deleteButton)
    }
    
    func constrainSubviews() {
        backButton.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.baseline.equalTo(titleLabel.snp_baseline)
        }
        
        titleLabel.snp_makeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop)
        }
        
        notificationsButton.snp_makeConstraints{(make)->Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidthWide)
        }
        
        notificationsLabel.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(notificationsButton.snp_bottom)
        }
        
        table.snp_makeConstraints {(make)->Void in
            make.top.equalTo(notificationsLabel.snp_bottom).offset(2 * CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(deleteLabel.snp_top).offset(-CIConstants.verticalItemSpacing)
        }
        
        deleteLabel.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(deleteButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
            make.bottom.equalTo(self.snp_bottomMargin).offset(-2 * CIConstants.verticalItemSpacing)
        }
        
        deleteButton.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(self.snp_bottomMargin).offset(-2 * CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
            
        }
    }
}