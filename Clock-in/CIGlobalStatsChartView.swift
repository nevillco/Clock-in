//
//  CIGlobalStatsChartView.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class CIGlobalStatsChartView: CIView {
    let topLine = UIView()
    let titleLabel = UILabel()
    let buttons:[CIButton]
    let chart:ChartViewBase
    let noDataLabel = UILabel()
    let selectionContainer = UIView()
    let selectedPointInfoLabel = UILabel()
    let selectedPointDataLabel = UILabel()
    
    required init(items: [CIModelItem], delegate: CIGlobalStatsChartDelegate) {
        buttons = items.map({ CIButton(primaryColor: UIColor.colorForItem($0), title: $0.name) })
        chart = delegate.chartType().init()
        noDataLabel.text = "No Data!\nLog some time on at least one of your selected items to view stats.".localized
        noDataLabel.backgroundColor = UIColor.whiteColor()
        super.init()
        backgroundColor = UIColor.whiteColor()
        setupSubviews()
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
        titleLabel.textColor = .blackColor()
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        addSubview(titleLabel)
        
        topLine.backgroundColor = .blackColor()
        addSubview(topLine)
        
        for button in buttons {
            button.permanentHighlight = true
            addSubview(button)
        }
        
        chart.noDataText = ""
        chart.noDataTextDescription = ""
        addSubview(chart)
        
        noDataLabel.font = UIFont.CIDefaultBodyFont
        noDataLabel.textColor = .blackColor()
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: noDataLabel.text!)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetTitleFont, range: (noDataLabel.text! as NSString).rangeOfString("No Data!"))
        noDataLabel.attributedText = attributedText
        noDataLabel.alpha = 0
        addSubview(noDataLabel)
        
        selectionContainer.backgroundColor = .blackColor()
        selectionContainer.layer.cornerRadius = CIConstants.cornerRadius
        addSubview(selectionContainer)
        
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
        let controls = [titleLabel, selectedPointDataLabel, selectedPointInfoLabel, selectionContainer]
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
        
        topLine.snp_remakeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
        
        titleLabel.snp_remakeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(topLine.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.leading.greaterThanOrEqualTo(self.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(self.snp_trailingMargin)
        }
        
        constrainButtons(0)
        
        noDataLabel.snp_remakeConstraints {(make)->Void in
            make.leading.greaterThanOrEqualTo(chart.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(chart.snp_trailingMargin)
            make.centerX.equalTo(chart.snp_centerX)
            make.centerY.equalTo(chart.snp_centerY)
        }
        
        selectedPointDataLabel.snp_remakeConstraints{(make)->Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(selectedPointInfoLabel.snp_bottom).offset(-CIConstants.chartLabelSpacing)
            make.bottom.equalTo(self.snp_bottom)
            make.leading.greaterThanOrEqualTo(self.snp_leadingMargin).offset(CIConstants.horizontalItemSpacing)
            make.trailing.lessThanOrEqualTo(self.snp_trailingMargin).offset(-CIConstants.horizontalItemSpacing)
        }
        
        selectedPointInfoLabel.snp_remakeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin).offset(CIConstants.horizontalItemSpacing)
            make.trailing.equalTo(self.snp_trailingMargin)
        }
        
        selectionContainer.snp_remakeConstraints{(make)->Void in
            make.leading.equalTo(self.snp_leadingMargin)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.top.equalTo(selectedPointInfoLabel.snp_top)
            make.bottom.equalTo(selectedPointDataLabel.snp_bottom)
        }
    }
}