//
//  CIStatsChartView.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class CIItemStatsChartView: CIView {
    let topLine = UIView()
    let titleLabel = UILabel()
    let buttons:[CIButton]
    let chart:ChartViewBase
    let noDataLabel = UILabel()
    let botLine = UIView()
    let selectedPointInfoLabel = UILabel()
    let selectedPointDataLabel = UILabel()
    
    required init(color: UIColor, delegate: CIItemStatsChartDelegate) {
        buttons = delegate.controlNames().map({ CIButton(primaryColor: .whiteColor(), title: $0) })
        chart = delegate.chartType().init()
        noDataLabel.text = "No Data!\nLog some time on this item to view stats.".localized
        noDataLabel.backgroundColor = color
        super.init()
        backgroundColor = color
        setupSubviews()
        //constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func animateTitleMessage(message:String) {
        UIView.animateWithDuration(1.0, animations: {
            self.titleLabel.alpha = 0
            self.titleLabel.text = message.localized
            self.titleLabel.alpha = 1
        })
    }
    
    func setupSubviews() {
        titleLabel.font = .CIChartTitleFont
        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        addSubview(titleLabel)
        
        for line in [topLine, botLine] {
            line.backgroundColor = .whiteColor()
            addSubview(line)
        }
        
        for button in buttons {
            addSubview(button)
        }
        
        chart.noDataText = ""
        chart.noDataTextDescription = ""
        addSubview(chart)
        
        noDataLabel.font = UIFont.CIDefaultBodyFont
        noDataLabel.textColor = .whiteColor()
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: noDataLabel.text!)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetTitleFont, range: (noDataLabel.text! as NSString).rangeOfString("No Data!"))
        noDataLabel.attributedText = attributedText
        noDataLabel.alpha = 0
        addSubview(noDataLabel)
        
        selectedPointInfoLabel.font = UIFont.CIStatsInfoLabelFont
        selectedPointInfoLabel.textColor = .whiteColor()
        selectedPointInfoLabel.numberOfLines = 1
        selectedPointInfoLabel.textAlignment = .Left
        selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
        addSubview(selectedPointInfoLabel)
        
        selectedPointDataLabel.font = UIFont.CIStatsDataLabelFont
        selectedPointDataLabel.textColor = .whiteColor()
        selectedPointDataLabel.numberOfLines = 1
        selectedPointDataLabel.textAlignment = .Center
        selectedPointDataLabel.text = " "
        selectedPointDataLabel.adjustsFontSizeToFitWidth = true
        selectedPointDataLabel.minimumScaleFactor = 0.5
        addSubview(selectedPointDataLabel)
        
        bringSubviewToFront(chart)
    }
    
    func constrainButtons(startIndex:Int) {
        let rowEnd = min(startIndex + 3, buttons.count)
        
        let aboveRef = startIndex == 0 ? titleLabel : buttons[startIndex - 1]
        for i in startIndex..<rowEnd {
            buttons[i].snp_makeConstraints{(make)->Void in
                make.top.equalTo(aboveRef.snp_bottom).offset(CIConstants.verticalItemSpacing)
                make.width.equalTo(CIConstants.buttonWidth)
            }
        }
        
        let rowCount = rowEnd - startIndex
        if rowCount == 1 {
            buttons[startIndex].snp_makeConstraints{(make)->Void in
                make.centerX.equalTo(self.snp_centerX)
            }
        }
        else if rowCount == 2 {
            buttons[startIndex].snp_makeConstraints{(make)->Void in
                make.trailing.equalTo(self.snp_centerX).offset(-0.5 * CIConstants.horizontalItemSpacing)
            }
            buttons[startIndex + 1].snp_makeConstraints{(make)->Void in
                make.leading.equalTo(self.snp_centerX).offset(0.5 * CIConstants.horizontalItemSpacing)
            }
        }
        else if rowCount == 3 {
            buttons[startIndex].snp_makeConstraints{(make)->Void in
                make.trailing.equalTo(buttons[startIndex + 1].snp_leading).offset(-CIConstants.horizontalItemSpacing)
            }
            buttons[startIndex + 1].snp_makeConstraints{(make)->Void in
                make.centerX.equalTo(self.snp_centerX)
            }
            buttons[startIndex + 2].snp_makeConstraints{(make)->Void in
                make.leading.equalTo(buttons[startIndex + 1].snp_trailing).offset(CIConstants.horizontalItemSpacing)
            }
        }
        if rowEnd < buttons.count {
            constrainButtons(rowEnd)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let isLandscape = UIDevice.currentDevice().orientation.isLandscape
        let controls = [titleLabel, selectedPointDataLabel, selectedPointInfoLabel]
        for control in controls {
            control.hidden = isLandscape
        }
        for button in buttons {
            button.hidden = isLandscape
        }
        chart.highlightPerTapEnabled = !isLandscape
        if isLandscape {
            chart.snp_remakeConstraints{(make)->Void in
                make.edges.equalTo(self)
            }
        }
        else {
            chart.snp_remakeConstraints{(make)->Void in
                let topGuide = (buttons.count > 0) ? buttons.last! : topLine
                make.top.equalTo(topGuide.snp_bottom).offset(CIConstants.verticalItemSpacing)
                make.leading.equalTo(self.snp_leading)
                make.trailing.equalTo(self.snp_trailing)
                make.bottom.equalTo(selectedPointInfoLabel.snp_top).offset(-CIConstants.verticalItemSpacing)
            }
        }
        
        topLine.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
        
        titleLabel.snp_makeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(topLine.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.leading.greaterThanOrEqualTo(self.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(self.snp_trailingMargin)
        }
        
        constrainButtons(0)
        
        noDataLabel.snp_makeConstraints {(make)->Void in
            make.leading.greaterThanOrEqualTo(chart.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(chart.snp_trailingMargin)
            make.centerX.equalTo(chart.snp_centerX)
            make.centerY.equalTo(chart.snp_centerY)
        }
        
        selectedPointDataLabel.snp_makeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(selectedPointInfoLabel.snp_bottom).offset(-CIConstants.chartLabelSpacing)
            make.bottom.equalTo(botLine.snp_top)
            make.leading.greaterThanOrEqualTo(self.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(self.snp_trailingMargin)
        }
        
        selectedPointInfoLabel.snp_makeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
        }
        
        botLine.snp_makeConstraints{(make)->Void in
            make.bottom.equalTo(self.snp_bottom)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
    }
}