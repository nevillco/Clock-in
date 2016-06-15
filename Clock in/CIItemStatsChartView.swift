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
    
    required init(manager: CIModelItemManager, delegate: CIItemStatsChartDelegate) {
        buttons = delegate.controlNames().map({ CIButton(primaryColor: .whiteColor(), title: $0) })
        chart = delegate.chartType().init()
        noDataLabel.text = String(format: "%@\n%@", "Not enough data!".localized, delegate.descriptionForNoData())
        noDataLabel.backgroundColor = UIColor.colorForItem(manager.item)
        super.init()
        backgroundColor = UIColor.colorForItem(manager.item)
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
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
        
        addSubview(chart)
        
        noDataLabel.font = UIFont.CIDefaultBodyFont
        noDataLabel.textColor = .whiteColor()
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: noDataLabel.text!)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetTitleFont, range: (noDataLabel.text! as NSString).rangeOfString("Not enough data!"))
        noDataLabel.attributedText = attributedText
        noDataLabel.alpha = 0
        addSubview(noDataLabel)
        
        selectedPointInfoLabel.font = UIFont.CIChartInfoLabelFont
        selectedPointInfoLabel.textColor = .whiteColor()
        selectedPointInfoLabel.numberOfLines = 1
        selectedPointInfoLabel.textAlignment = .Left
        selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
        addSubview(selectedPointInfoLabel)
        
        selectedPointDataLabel.font = UIFont.CIChartDataLabelFont
        selectedPointDataLabel.textColor = .whiteColor()
        selectedPointDataLabel.numberOfLines = 1
        selectedPointDataLabel.textAlignment = .Center
        selectedPointDataLabel.text = " "
        selectedPointDataLabel.adjustsFontSizeToFitWidth = true
        selectedPointDataLabel.minimumScaleFactor = 0.5
        addSubview(selectedPointDataLabel)
    }
    
    func constrainSubviews() {
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
        
        for i in 0..<buttons.count {
            buttons[i].snp_makeConstraints{(make)->Void in
                make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
                make.width.equalTo(CIConstants.buttonWidth)
            }
        }
        if buttons.count == 1 {
            buttons[0].snp_makeConstraints{(make)->Void in
                make.centerX.equalTo(self.snp_centerX)
            }
        }
        else if buttons.count == 2 {
            buttons[0].snp_makeConstraints{(make)->Void in
                make.trailing.equalTo(self.snp_centerX).offset(-0.5 * CIConstants.horizontalItemSpacing)
            }
            buttons[1].snp_makeConstraints{(make)->Void in
                make.leading.equalTo(self.snp_centerX).offset(0.5 * CIConstants.horizontalItemSpacing)
            }
        }
        else if buttons.count == 3 {
            buttons[0].snp_makeConstraints{(make)->Void in
                make.trailing.equalTo(buttons[1].snp_leading).offset(-CIConstants.horizontalItemSpacing)
            }
            buttons[1].snp_makeConstraints{(make)->Void in
                make.centerX.equalTo(self.snp_centerX)
            }
            buttons[2].snp_makeConstraints{(make)->Void in
                make.leading.equalTo(buttons[1].snp_trailing).offset(CIConstants.horizontalItemSpacing)
            }
            
        }
        
        chart.snp_makeConstraints{(make)->Void in
            let topGuide = (buttons.count > 0) ? buttons[0] : topLine
            make.top.equalTo(topGuide.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(selectedPointInfoLabel.snp_top).offset(-CIConstants.verticalItemSpacing)
        }
        
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