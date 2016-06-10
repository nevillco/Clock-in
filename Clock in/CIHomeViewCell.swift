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
    let statsButton = CIButton(primaryColor: .CIGreen, title: "stats".localized)
    let settingsButton = CIButton(primaryColor: .CIGray, title: "settings".localized)
    let bottomLine = UIView()
    
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
        nameLabel.font = UIFont.CIDefaultBodyFont
        nameLabel.numberOfLines = 1
        addSubview(nameLabel)
        
        addSubview(statsButton)
        addSubview(settingsButton)
        
        bottomLine.backgroundColor = .CIBlue
        addSubview(bottomLine)
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
            make.topMargin.equalTo(self.snp_topMargin)
        }
        
        statsButton.snp_makeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.bottom.equalTo(bottomLine.snp_top).offset(-CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        settingsButton.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(statsButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.bottom.equalTo(bottomLine.snp_top).offset(-CIConstants.verticalItemSpacing)
            make.width.equalTo(CIConstants.buttonWidth)
        }
        
        bottomLine.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(clockButton.snp_trailing)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(clockButton.snp_bottom)
            make.height.equalTo(1)
        }
    }
    
    class CIHomeCellButton: UIButton {
        static let buttonInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let primaryColor:UIColor
        
        override var highlighted: Bool {
            didSet {
                if (highlighted) {
                    setTitleColor(primaryColor, forState: .Highlighted)
                    backgroundColor = .whiteColor()
                }
                else {
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
            setTitle("in".localized, forState: .Normal)
            setTitleColor(.whiteColor(), forState: .Normal)
            titleLabel!.font = UIFont.CIHomeCellClockButtonFont
            layer.borderColor = primaryColor.CGColor
            layer.borderWidth = 1
        }
        
        func highlightedTitleColor() -> UIColor? {
            if(self.superview == nil) { return nil }
            if(self.superview!.backgroundColor == nil) { return .whiteColor() }
            return self.superview!.backgroundColor
        }
    }
}
