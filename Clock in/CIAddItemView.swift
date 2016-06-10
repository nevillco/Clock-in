//
//  CIAddItemView.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation
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
    let colorLabel = UILabel()
    let colorCollection = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init() {
        super.init()
        backgroundColor = .CIBlue
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
        backButton.setTitle("‹go back".localized, forState: .Normal)
        backButton.titleLabel!.font = UIFont.CITextButtonFont
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
        goButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        addSubview(goButton)
        
        colorLabel.text = "Select one of the colors below. This color will be associated with your item when you view its stats.".localized
        colorLabel.font = UIFont.CIDefaultBodyFont
        colorLabel.textColor = .whiteColor()
        colorLabel.numberOfLines = 0
        addSubview(colorLabel)
        
        colorCollection.backgroundColor = UIColor.clearColor()
        addSubview(colorCollection)
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
        
        colorLabel.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(nameField.snp_bottom).offset(CIConstants.verticalItemSpacing * 2)
        }
        
        colorCollection.snp_makeConstraints { (make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(colorLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.bottom.equalTo(self.snp_bottomMargin)
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
    }
    
    func checkNameFieldAlignment() {
        let text = NSString(string: nameField.text!)
        let attributes = [NSFontAttributeName: UIFont.CITextFieldFont]
        let textWidth = text.sizeWithAttributes(attributes).width
        let maxWidth = nameField.editingRectForBounds(nameField.bounds).width
        if(textWidth >= maxWidth) {
            nameField.textAlignment = .Right
        }
        else {
            nameField.textAlignment = .Left
        }
    }
}