//
//  CIRewindView.swift
//  Clock in
//
//  Created by Connor Neville on 6/14/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIRewindView: CIView {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let picker = UIDatePicker()
    let timerLabel = UILabel()
    let goButton = UIButton()
    
    var timer:NSTimer?
    
    required init(backgroundColor: UIColor) {
        super.init()
        self.backgroundColor = backgroundColor
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
        
        titleLabel.text = "rewind".localized
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        infoLabel.text = "Use the picker below to rewind how long you've been clocked in for. This is useful for when you forgot to clock out after finishing something.".localized
        infoLabel.font = UIFont.CIDefaultBodyFont
        infoLabel.textColor = .whiteColor()
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        
        picker.datePickerMode = .CountDownTimer
        picker.setValue(UIColor.whiteColor(), forKey: "textColor")
        addSubview(picker)
        
        timerLabel.text = "You've been clocked in for "
        timerLabel.font = UIFont.CIBoldBodyFont
        timerLabel.textColor = .whiteColor()
        timerLabel.numberOfLines = 0
        addSubview(timerLabel)
        
        goButton.setTitle("rewind›".localized, forState: .Normal)
        goButton.titleLabel!.font = UIFont.CILargeTextButtonFont
        goButton.setTitleColor(.whiteColor(), forState: .Normal)
        goButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(goButton)
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
        
        infoLabel.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(titleLabel.snp_bottom)
        }
        
        timerLabel.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(infoLabel.snp_bottom)
        }
        
        picker.snp_makeConstraints {(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(timerLabel.snp_bottom)
        }
        
        goButton.snp_makeConstraints {(make)->Void in
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(picker.snp_bottom).offset(CIConstants.verticalItemSpacing)
        }
    }
    
    func startTimer(startTime:NSDate) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateDurationLabel), userInfo: startTime, repeats: true)
    }
    
    func resetTimer() {
        timer!.invalidate()
        timer = nil
    }
    
    func updateDurationLabel() {
        let startTime = timer!.userInfo as! NSDate
        let interval = NSDate().timeIntervalSinceDate(startTime)
        self.timerLabel.text = String(format: "You've been clocked in for %@.", NSDate.longStringForInterval(Int(interval)))
    }
}