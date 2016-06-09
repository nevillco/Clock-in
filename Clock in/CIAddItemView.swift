//
//  CIAddItemView.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIAddItemView: CIView {
    static let textFieldConstantHeight:CGFloat = 30
    static let charsLabelConstantWidth = 26
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let charsLabel = UILabel()
    let nameField = CITextField(placeholder: "item name")
    let goButton = UIButton()
    
    let table = UITableView()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .CIBlue
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
        
        titleLabel.text = "add item".localized
        titleLabel.font = UIFont.CIDefaultTitleFont
        titleLabel.textColor = .whiteColor()
        addSubview(titleLabel)
        
        nameLabel.text = String(format: "Use the field below to enter the name of a new task, hobby, interest, sport or other activity for which you'd like to track your productivity. Items can be up to %d characters.", CIConstants.itemMaxChars).localized
        nameLabel.font = UIFont.CIDefaultBodyFont
        nameLabel.textColor = .whiteColor()
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
        
        charsLabel.text = String(CIConstants.itemMaxChars)
        charsLabel.textColor = .whiteColor()
        charsLabel.font = .CITextFieldFont
        addSubview(charsLabel)
        
        nameField.setContentHuggingPriority(249, forAxis: .Horizontal)
        nameField.returnKeyType = .Go
        addSubview(nameField)
        
        goButton.setTitle("go›".localized, forState: .Normal)
        goButton.titleLabel!.font = .CITextFieldFont
        goButton.setTitleColor(.whiteColor(), forState: .Normal)
        goButton.setTitleColor(.CIGray, forState: .Highlighted)
        addSubview(goButton)
    }
    
    func constrainSubviews() {
        backButton.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.topMargin.equalTo(self).offset(CIConstants.paddingFromTop)
        }
        
        titleLabel.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.topMargin.equalTo(backButton.snp_bottom)
        }
        
        nameLabel.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(titleLabel.snp_bottom)
        }
        
        charsLabel.snp_makeConstraints { (make)->Void in
            make.centerY.equalTo(nameField.snp_centerY)
            make.leading.equalTo(self.snp_leadingMargin)
            make.width.equalTo(CIAddItemView.charsLabelConstantWidth)
        }
        
        nameField.snp_makeConstraints { (make)->Void in
            make.top.equalTo(nameLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.height.equalTo(CIAddItemView.textFieldConstantHeight)
            make.leading.equalTo(charsLabel.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.trailing.equalTo(goButton.snp_leading).offset(-CIConstants.horizontalItemSpacing)
        }
        
        goButton.snp_makeConstraints { (make)->Void in
            make.centerY.equalTo(nameField.snp_centerY)
            make.trailing.equalTo(self.snp_trailingMargin)
        }
    }
    
    func updateCharsLabel(charsRemaining: Int) {
        charsLabel.text = String(charsRemaining)
        if charsRemaining < 0 {
            charsLabel.textColor = UIColor.CIRed
        }
        else if charsRemaining <= CIConstants.charsRemainingForWarning {
            charsLabel.textColor = UIColor.CIYellow
        }
        else {
            charsLabel.textColor = UIColor.whiteColor()
        }
        print(charsLabel.frame.width)
    }
}