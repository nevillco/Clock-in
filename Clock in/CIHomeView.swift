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
    
    let addItemButton = CIButton(primaryColor: UIColor.CIBlue(), title: "add item".localized)
    let globalStatsButton = CIButton(primaryColor: UIColor.CIGreen(), title: "global stats".localized)
    let globalSettingsButton = CIButton(primaryColor: UIColor.CIGray(), title: "options".localized)
    
    init() {
        super.init(frame: CGRectZero)
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(String.initCoderError())
    }
    
    func setupSubviews() {
        titleLabel.font = UIFont.CIHomeTitleLightFont()
        let titleText = "Clock:in"
        let definedText = "in"
        let attributedText = NSMutableAttributedString(string: titleText.localized)
        attributedText.addAttributes(
            [NSForegroundColorAttributeName: UIColor.CIBlue(),
                NSFontAttributeName: UIFont.CIHomeTitleBoldFont()], range: (titleText as NSString).rangeOfString(definedText))
        titleLabel.attributedText = attributedText
        addSubview(titleLabel)
        
        addSubview(addItemButton)
        addSubview(globalStatsButton)
        addSubview(globalSettingsButton)
    }
    
    func constrainSubviews() {
        titleLabel.snp_makeConstraints { (make)->Void in
            make.centerX.equalTo(self)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop)
        }
        
        globalStatsButton.snp_makeConstraints { (make)->Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        globalSettingsButton.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(globalStatsButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.top.equalTo(globalStatsButton.snp_top)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        addItemButton.snp_makeConstraints { (make)->Void in
            make.trailing.equalTo(globalStatsButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
            make.top.equalTo(globalStatsButton.snp_top)
            make.width.equalTo(CIConstants.buttonWidth)
        }
    }
}