//
//  CIHomeViewCell.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit


class CIHomeViewCell: CITableViewCell {
    static let customReuseIdentifier = "Home"
    
    let clockButton = CIHomeCellButton(primaryColor: .CIBlue)
    let nameLabel = UILabel()
    let statsButton = UIButton()
    let settingsButton = UIButton()
    let clockDurationLabel = UILabel()
    let controlContainer = CIView()
    
    var timer:NSTimer?
    
    var primaryColor = UIColor.clearColor() {
        didSet {
            clockButton.primaryColor = primaryColor
            controlContainer.backgroundColor = primaryColor
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        constrainSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        addSubview(clockButton)
        
        nameLabel.text = "Item name"
        nameLabel.font = UIFont.CIHomeCellTextFont
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        addSubview(nameLabel)
        
        controlContainer.backgroundColor = primaryColor
        controlContainer.layer.cornerRadius = 4
        addSubview(controlContainer)
        
        statsButton.setTitle("stats".localized, forState: .Normal)
        statsButton.setTitleColor(.whiteColor(), forState: .Normal)
        statsButton.setTitleColor(.CIGray, forState: .Highlighted)
        statsButton.titleLabel!.font = UIFont.CITextButtonFont
        controlContainer.addSubview(statsButton)
        
        settingsButton.setTitle("settings".localized, forState: .Normal)
        settingsButton.setTitleColor(.whiteColor(), forState: .Normal)
        settingsButton.setTitleColor(.CIGray, forState: .Highlighted)
        settingsButton.titleLabel!.font = UIFont.CITextButtonFont
        controlContainer.addSubview(settingsButton)
        
        clockDurationLabel.text = "00:00"
        clockDurationLabel.textColor = .whiteColor()
        clockDurationLabel.font = UIFont.CITextButtonFont
        clockDurationLabel.numberOfLines = 1
        clockDurationLabel.alpha = 0
        controlContainer.addSubview(clockDurationLabel)
        
        sendSubviewToBack(controlContainer)
    }
    
    func constrainSubviews() {
        clockButton.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leading)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom).offset(-4)
            make.width.greaterThanOrEqualTo(clockButton.snp_height)
        }
        
        nameLabel.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(clockButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.trailing.lessThanOrEqualTo(self.snp_trailing)
            make.bottom.equalTo(controlContainer.snp_top).offset(-CIConstants.verticalItemSpacing)
        }
        
        statsButton.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(settingsButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
            make.centerY.equalTo(controlContainer.snp_centerY)
        }
        
        settingsButton.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(controlContainer.snp_trailingMargin)
            make.centerY.equalTo(controlContainer.snp_centerY)
        }
        
        clockDurationLabel.snp_makeConstraints{(make)->Void in
            make.trailing.equalTo(controlContainer.snp_trailingMargin)
            make.centerY.equalTo(controlContainer.snp_centerY)
        }
        
        controlContainer.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(clockButton.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(clockButton.snp_bottom)
            make.height.equalTo(statsButton.snp_height)
        }
    }
    
    func applyClockedStyle(clockedIn: Bool) {
        if(clockedIn) {
            UIView.transitionWithView(clockButton, duration: 0.5, options: .TransitionFlipFromRight, animations: {
                self.clockButton.setImage(nil, forState: .Normal)
                self.clockButton.setTitle("in", forState: .Normal)
                }, completion: nil)
            self.layoutIfNeeded()
            statsButton.snp_remakeConstraints{(make)->Void in
                make.leading.equalTo(self.snp_trailing).offset(5 * CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            settingsButton.snp_remakeConstraints{(make)->Void in
                make.leading.equalTo(statsButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            UIView.animateWithDuration(0.5, animations: {
                self.layoutIfNeeded()
                }, completion: {_ in
                    UIView.animateWithDuration(0.25) {
                        self.clockDurationLabel.alpha = 1
                    }
            })
        }
        else {
            let image = UIImage(named: "clockIcon50")?.imageWithRenderingMode(.AlwaysTemplate)
            UIView.transitionWithView(clockButton, duration: 0.5, options: .TransitionFlipFromRight, animations: {
                self.clockButton.setImage(image, forState: .Normal)
                self.clockButton.imageView!.tintColor = .whiteColor()
                self.clockButton.setTitle("", forState: .Normal)
                }, completion: nil)
            self.layoutIfNeeded()
            statsButton.snp_remakeConstraints{(make)->Void in
                make.trailing.equalTo(settingsButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            settingsButton.snp_remakeConstraints{(make)->Void in
                make.trailing.equalTo(controlContainer.snp_trailingMargin)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            UIView.animateWithDuration(0.5, animations: {
                self.clockDurationLabel.alpha = 0
                }, completion: nil)
            UIView.animateWithDuration(0.25, delay: 0.6, options: .CurveEaseIn, animations: {
                self.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func displayTimer(startTime:NSDate) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateDurationLabel), userInfo: startTime, repeats: true)
    }
    
    func updateDurationLabel() {
        let startTime = timer!.userInfo as! NSDate
        let interval = NSDate().timeIntervalSinceDate(startTime)
        self.clockDurationLabel.text = stringFromTimeInterval(interval)
    }
    
    private func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return (hours == 0) ? String(format: "%02d:%02d", minutes, seconds) : String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    class CIHomeCellButton: UIButton {
        static let buttonInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        var primaryColor:UIColor {
            didSet {
                layer.borderColor = primaryColor.CGColor
                backgroundColor = primaryColor
            }
        }
        
        override var highlighted: Bool {
            didSet {
                if (highlighted) {
                    imageView!.tintColor = primaryColor
                    setTitleColor(primaryColor, forState: .Highlighted)
                    backgroundColor = .whiteColor()
                }
                else {
                    imageView!.tintColor = .whiteColor()
                    setTitleColor(.whiteColor(), forState: .Highlighted)
                    backgroundColor = primaryColor
                }
            }
        }
        
        required init(primaryColor: UIColor) {
            self.primaryColor = primaryColor
            super.init(frame: CGRectZero)
            setDefaultStyle()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError(CIError.CoderInitUnimplementedString)
        }
        
        func setDefaultStyle() {
            backgroundColor = primaryColor
            let image = UIImage(named: "clockIcon50")?.imageWithRenderingMode(.AlwaysTemplate)
            setImage(image, forState: .Normal)
            imageView!.tintColor = .whiteColor()
            setTitle("", forState: .Normal)
            titleLabel!.font = UIFont.CIHomeCellClockButtonFont
            setTitleColor(.whiteColor(), forState: .Normal)
            setTitleColor(primaryColor, forState: .Highlighted)
            layer.borderColor = primaryColor.CGColor
            layer.borderWidth = 2
            layer.cornerRadius = 4
        }
        
        func highlightedTitleColor() -> UIColor? {
            if(self.superview == nil) { return nil }
            if(self.superview!.backgroundColor == nil) { return .whiteColor() }
            return self.superview!.backgroundColor
        }
    }
}
