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
    let clockButton = CIHomeCellButton(primaryColor: .CIBlue)
    let nameLabel = UILabel()
    let statsButton = UIButton()
    let settingsButton = UIButton()
    let controlContainer = CIView()
    
    let clockDurationLabel = UILabel()
    let adjustButton = UIButton()
    let cancelButton = UIButton()
    
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
        controlContainer.layer.cornerRadius = CIConstants.cornerRadius()
        controlContainer.userInteractionEnabled = true
        addSubview(controlContainer)
        
        statsButton.setTitle("stats".localized, forState: .Normal)
        statsButton.setTitleColor(.whiteColor(), forState: .Normal)
        statsButton.setTitleColor(.CIGray, forState: .Highlighted)
        statsButton.titleLabel!.font = UIFont.CITextButtonFont()
        controlContainer.addSubview(statsButton)
        
        settingsButton.setTitle("settings".localized, forState: .Normal)
        settingsButton.setTitleColor(.whiteColor(), forState: .Normal)
        settingsButton.setTitleColor(.CIGray, forState: .Highlighted)
        settingsButton.titleLabel!.font = UIFont.CITextButtonFont()
        controlContainer.addSubview(settingsButton)
        
        clockDurationLabel.text = ""
        clockDurationLabel.textColor = .whiteColor()
        clockDurationLabel.font = UIFont.CITimerTextFont
        clockDurationLabel.numberOfLines = 1
        clockDurationLabel.alpha = 0
        controlContainer.addSubview(clockDurationLabel)
        
        adjustButton.setTitle("adjust".localized, forState: .Normal)
        adjustButton.setTitleColor(.whiteColor(), forState: .Normal)
        adjustButton.setTitleColor(.CIGray, forState: .Highlighted)
        adjustButton.titleLabel!.font = UIFont.CITextButtonFont()
        adjustButton.alpha = 0
        controlContainer.addSubview(adjustButton)
        
        cancelButton.setTitle("cancel".localized, forState: .Normal)
        cancelButton.setTitleColor(.whiteColor(), forState: .Normal)
        cancelButton.setTitleColor(.CIGray, forState: .Highlighted)
        cancelButton.titleLabel!.font = UIFont.CITextButtonFont()
        cancelButton.alpha = 0
        controlContainer.addSubview(cancelButton)
        
        bringSubviewToFront(clockButton)
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
        
        adjustButton.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(clockButton.snp_trailing)
            make.centerY.equalTo(controlContainer.snp_centerY)
        }
        
        cancelButton.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(adjustButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.centerY.equalTo(controlContainer.snp_centerY)
        }
        
        controlContainer.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(clockButton.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(clockButton.snp_bottom)
            make.height.equalTo(statsButton.snp_height)
        }
    }
}

typealias CIHomeViewCellStyling = CIHomeViewCell
extension CIHomeViewCellStyling {
    func applyClockedStyle(clockedIn: Bool, animated: Bool) {
        self.layoutIfNeeded()
        makeButtonConstraints(clockedIn)
        changeClockButton(clockedIn)
        changeVisibleSubviews(clockedIn, animated: animated)
    }
    
    private func changeClockButton(clockedIn:Bool) {
        if(clockedIn) {
            UIView.performWithoutAnimation({
                self.clockButton.setImage(nil, forState: .Normal)
                self.clockButton.setTitle("in", forState: .Normal)
                self.clockButton.layoutIfNeeded()
            })
        }
        else {
            let image = UIImage(named: "homecell81")?.imageWithRenderingMode(.AlwaysTemplate)
            UIView.performWithoutAnimation({
                self.clockButton.setImage(image, forState: .Normal)
                self.clockButton.imageView!.tintColor = .whiteColor()
                self.clockButton.setTitle("", forState: .Normal)
                self.clockButton.layoutIfNeeded()
            })
        }
    }
    
    private func makeButtonConstraints(clockedIn:Bool) {
        if(clockedIn) {
            statsButton.snp_remakeConstraints{(make)->Void in
                make.leading.equalTo(self.snp_trailing).offset(5 * CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            settingsButton.snp_remakeConstraints{(make)->Void in
                make.leading.equalTo(statsButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
        }
        else {
            statsButton.snp_remakeConstraints{(make)->Void in
                make.trailing.equalTo(settingsButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
            settingsButton.snp_remakeConstraints{(make)->Void in
                make.trailing.equalTo(controlContainer.snp_trailingMargin)
                make.centerY.equalTo(controlContainer.snp_centerY)
            }
        }
    }
    
    private func changeVisibleSubviews(clockedIn:Bool, animated:Bool) {
        if(animated) {
            if(clockedIn) {
                UIView.animateWithDuration(0.5, animations: {
                    self.layoutIfNeeded()
                    }, completion: nil)
                UIView.animateWithDuration(0.25, delay: 0.6, options: .CurveEaseIn, animations: {
                    self.clockDurationLabel.alpha = 1
                    self.adjustButton.alpha = 1
                    self.cancelButton.alpha = 1
                    }, completion: nil)
                
            }
            else {
                UIView.animateWithDuration(0.5, animations: {
                    self.clockDurationLabel.alpha = 0
                    self.adjustButton.alpha = 0
                    self.cancelButton.alpha = 0
                    }, completion: {_ in
                        self.clockDurationLabel.text = "0s" })
                UIView.animateWithDuration(0.25, delay: 0.6, options: .CurveEaseIn, animations: {
                    self.layoutIfNeeded()
                    }, completion: nil)
            }
        }
        else {
            if(clockedIn) {
                self.clockDurationLabel.alpha = 1
                self.adjustButton.alpha = 1
                self.cancelButton.alpha = 1
                self.layoutIfNeeded()
            }
            else {
                self.clockDurationLabel.alpha = 0
                self.adjustButton.alpha = 0
                self.cancelButton.alpha = 0
                self.layoutIfNeeded()
            }
        }
    }
}

typealias CIHomeViewCellTimer = CIHomeViewCell
extension CIHomeViewCellTimer {
    func startTimer(manager:CIModelItemManager) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateDurationLabel), userInfo: manager, repeats: true)
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateDurationLabel() {
        if timer == nil { return }
        let manager = timer!.userInfo as! CIModelItemManager
        let interval = manager.currentClockTime()
        self.clockDurationLabel.text = NSDate.stringForInterval(Int(interval))
    }
}

class CIHomeCellButton: UIButton {
    static let buttonInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    var timer: NSTimer?
    
    var primaryColor:UIColor {
        didSet {
            layer.borderColor = primaryColor.CGColor
            backgroundColor = primaryColor
        }
    }
    
    var permanentHighlight: Bool {
        didSet {
            applyStyle(permanentHighlight)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            applyStyle(permanentHighlight ? !highlighted : highlighted)
        }
    }
    
    required init(primaryColor: UIColor) {
        self.primaryColor = primaryColor
        self.permanentHighlight = false
        super.init(frame: CGRectZero)
        setDefaultStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setDefaultStyle() {
        backgroundColor = primaryColor
        let image = UIImage(named: "homecell81")?.imageWithRenderingMode(.AlwaysTemplate)
        setImage(image, forState: .Normal)
        imageView!.tintColor = .whiteColor()
        setTitle("", forState: .Normal)
        titleLabel!.font = UIFont.CIHomeCellClockButtonFont
        setTitleColor(.whiteColor(), forState: .Normal)
        setTitleColor(primaryColor, forState: .Highlighted)
        layer.borderColor = primaryColor.CGColor
        layer.borderWidth = CIConstants.borderWidth()
        layer.cornerRadius = CIConstants.cornerRadius()
    }
    
    func highlightedTitleColor() -> UIColor? {
        if(self.superview == nil) { return nil }
        if(self.superview!.backgroundColor == nil) { return .whiteColor() }
        return self.superview!.backgroundColor
    }
    
    func startFlicker() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(flicker(_:)), userInfo: nil, repeats: true)
    }
    
    func applyStyle(highlighted:Bool) {
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
    
    func stopFlicker() {
        self.timer?.invalidate()
        self.timer = nil
        self.permanentHighlight = false
    }
    
    func flicker(sender: AnyObject) {
        self.permanentHighlight = !self.permanentHighlight
    }
}
