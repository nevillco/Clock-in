//
//  CIAdjustView.swift
//  Clock in
//
//  Created by Connor Neville on 6/14/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIAdjustView: CIView {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let rewindButton = CIButton(primaryColor: .whiteColor(), title: "Rewind".localized)
    let forwardButton = CIButton(primaryColor: .whiteColor(), title: "Forward".localized)
    let picker = UIDatePicker()
    let timerLabel = UILabel()
    let goButton = UIButton()
    
    var timer:NSTimer?
    
    required init(backgroundColor: UIColor) {
        super.init()
        self.backgroundColor = backgroundColor
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
        
        titleLabel.text = "adjust".localized
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        infoLabel.text = "Use the picker below to adjust how long you've been clocked in, in case you forgot to clock in or out earlier.".localized
        infoLabel.font = UIFont.CIDefaultBodyFont
        infoLabel.textColor = .whiteColor()
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        
        timerLabel.text = "You've been clocked in for "
        timerLabel.font = UIFont.CIBoldBodyFont
        timerLabel.textColor = .whiteColor()
        timerLabel.numberOfLines = 0
        addSubview(timerLabel)
        
        addSubview(rewindButton)
        addSubview(forwardButton)
        
        picker.datePickerMode = .CountDownTimer
        picker.setValue(UIColor.whiteColor(), forKey: "textColor")
        addSubview(picker)
        
        goButton.setTitle("adjust›".localized, forState: .Normal)
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
        
        timerLabel.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(infoLabel.snp_bottom)
        }
        
        rewindButton.snp_remakeConstraints{(make)->Void in
            make.trailing.equalTo(self.snp_centerX).offset(-0.5 * CIConstants.horizontalItemSpacing)
            make.top.equalTo(timerLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        forwardButton.snp_remakeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_centerX).offset(0.5 * CIConstants.horizontalItemSpacing)
            make.top.equalTo(timerLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        picker.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(rewindButton.snp_bottom)
        }
        
        goButton.snp_remakeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(picker.snp_bottom).offset(CIConstants.verticalItemSpacing)
        }
    }
    
    func startTimer(manager:CIModelItemManager) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateDurationLabel), userInfo: manager, repeats: true)
    }
    
    func resetTimer() {
        timer!.invalidate()
        timer = nil
    }
    
    func updateDurationLabel() {
        let manager = timer!.userInfo as! CIModelItemManager
        let interval = manager.currentClockTime()
        self.timerLabel.text = String(format: "You've been clocked in for %@.", NSDate.longStringForInterval(Int(interval)))
    }
}