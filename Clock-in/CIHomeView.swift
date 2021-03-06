//
//  CIHomeView.swift
//  Clock in
//
//  View for home screen.
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIHomeView: CIView {
    
    let titleLabel = UILabel()
    
    let addItemButton = CIButton(primaryColor: .CIBlue, title: "add item".localized)
    let globalStatsButton = CIButton(primaryColor: .CIGreen, title: "all stats".localized)
    let globalSettingsButton = CIButton(primaryColor: .CIGray, title: "settings".localized)
    
    let table = UITableView()
    
    override init() {
        super.init()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        titleLabel.font = UIFont.CIHomeTitleLightFont
        let titleText = "Clock:in"
        let definedText = "in"
        let attributedText = NSMutableAttributedString(string: titleText.localized)
        attributedText.addAttributes(
            [NSForegroundColorAttributeName: UIColor.CIBlue,
                NSFontAttributeName: UIFont.CIHomeTitleRegularFont], range: (titleText as NSString).rangeOfString(definedText))
        titleLabel.attributedText = attributedText
        addSubview(titleLabel)
        
        addSubview(addItemButton)
        addSubview(globalStatsButton)
        addSubview(globalSettingsButton)
        
        table.separatorStyle = .None
        table.allowsSelection = false
        addSubview(table)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp_remakeConstraints { (make)->Void in
            make.centerX.equalTo(self)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop())
        }
        
        globalStatsButton.snp_remakeConstraints { (make)->Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth())
        }
        
        globalSettingsButton.snp_remakeConstraints { (make)->Void in
            make.leading.equalTo(globalStatsButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.top.equalTo(globalStatsButton.snp_top)
            make.width.equalTo(CIConstants.buttonWidth())
        }
        
        addItemButton.snp_remakeConstraints { (make)->Void in
            make.trailing.equalTo(globalStatsButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
            make.top.equalTo(globalStatsButton.snp_top)
            make.width.equalTo(CIConstants.buttonWidth())
        }
        
        table.snp_remakeConstraints { (make)->Void in
            make.top.equalTo(globalStatsButton.snp_bottom).offset(2 * CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(self.snp_bottom)
        }
    }
}