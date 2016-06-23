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
    let contactContainer = CIView()
    let contactLabel = UILabel()
    let contactButton = CIButton(primaryColor: .whiteColor(), title: "contact dev".localized)
    
    override init() {
        super.init()
        backgroundColor = .CIGray
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        backButton.setTitle("‹go back".localized, forState: .Normal)
        backButton.titleLabel!.font = UIFont.CILargeTextButtonFont()
        backButton.setTitleColor(.whiteColor(), forState: .Normal)
        backButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(backButton)
        
        titleLabel.text = "settings".localized
        titleLabel.font = UIFont.CIDefaultTitleFont()
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        addSubview(notificationsButton)
        
        notificationsLabel.text = "If you want, you can have an item send notifications after certain amounts of time. You can also change notifications on specific items by going to their settings.".localized
        notificationsLabel.font = UIFont.CIDefaultBodyFont()
        notificationsLabel.textColor = .whiteColor()
        notificationsLabel.numberOfLines = 0
        addSubview(notificationsLabel)
        
        table.separatorStyle = .None
        table.allowsSelection = false
        table.backgroundColor = .clearColor()
        addSubview(table)
        
        contactContainer.backgroundColor = .CIBlue
        contactContainer.layer.cornerRadius = CIConstants.cornerRadius()
        addSubview(contactContainer)
        
        contactLabel.text = "I'm always looking to improve this app. If you spot any bugs or have ideas, email me here.".localized
        contactLabel.font = UIFont.CIDefaultBodyFont()
        contactLabel.textColor = .whiteColor()
        contactLabel.numberOfLines = 0
        contactContainer.addSubview(contactLabel)
        
        contactContainer.addSubview(contactButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isLandscape = UIDevice.currentDevice().orientation.isLandscape
        notificationsLabel.hidden = isLandscape
        if isLandscape {
            table.snp_remakeConstraints {(make)->Void in
                make.top.equalTo(notificationsButton.snp_bottom).offset(CIConstants.verticalItemSpacing)
                make.leading.equalTo(self.snp_leadingMargin)
                make.trailing.equalTo(self.snp_trailingMargin)
                make.bottom.equalTo(contactContainer.snp_top).offset(-CIConstants.verticalItemSpacing)
            }
        }
        else {
            table.snp_remakeConstraints {(make)->Void in
                make.top.equalTo(notificationsLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
                make.leading.equalTo(self.snp_leadingMargin)
                make.trailing.equalTo(self.snp_trailingMargin)
                make.bottom.equalTo(contactContainer.snp_top).offset(-CIConstants.verticalItemSpacing)
            }
        }
        
        backButton.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.baseline.equalTo(titleLabel.snp_baseline)
        }
        
        titleLabel.snp_remakeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop())
        }
        
        notificationsButton.snp_remakeConstraints{(make)->Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidthWide())
        }
        
        notificationsLabel.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(notificationsButton.snp_bottom).offset(CIConstants.verticalItemSpacing)
        }
        
        contactContainer.snp_makeConstraints{(make)->Void in
            make.top.equalTo(contactLabel.snp_top).offset(-2 * CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(self.snp_bottomMargin).offset(-CIConstants.paddingFromTop())
        }
        
        contactLabel.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(contactContainer.snp_leadingMargin)
            make.trailing.equalTo(contactButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
            make.bottom.equalTo(contactContainer.snp_bottomMargin).offset(-CIConstants.verticalItemSpacing)
        }
        
        contactButton.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(contactContainer.snp_trailingMargin)
            make.centerY.equalTo(contactContainer.snp_centerY)
            make.width.equalTo(CIConstants.buttonWidth())
        }
    }
}