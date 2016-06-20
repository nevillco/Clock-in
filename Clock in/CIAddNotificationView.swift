//
//  CIAddNotificationView.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIAddNotificationView: CIView {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let picker = UIDatePicker()
    let goButton = UIButton()
    
    override init() {
        super.init()
        backgroundColor = .CIPurple
        setupSubviews()
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
        
        titleLabel.text = "add time".localized
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        infoLabel.text = "Use the picker below to select a time to be notified.".localized
        infoLabel.font = UIFont.CIDefaultBodyFont
        infoLabel.textColor = .whiteColor()
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        
        picker.datePickerMode = .CountDownTimer
        picker.setValue(UIColor.whiteColor(), forKey: "textColor")
        addSubview(picker)
        
        goButton.setTitle("add notification time›".localized, forState: .Normal)
        goButton.titleLabel!.font = UIFont.CILargeTextButtonFont
        goButton.setTitleColor(.whiteColor(), forState: .Normal)
        goButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(goButton)
    }
    
    override func layoutSubviews() {
        backButton.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.baseline.equalTo(titleLabel.snp_baseline)
        }
        
        titleLabel.snp_remakeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop())
        }
        
        infoLabel.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(titleLabel.snp_bottom)
        }
        
        picker.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(infoLabel.snp_bottom)
        }
        
        goButton.snp_remakeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(picker.snp_bottom).offset(CIConstants.verticalItemSpacing)
        }
    }
}