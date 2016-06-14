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
    let buttons:[CIButton]
    let chart:ChartViewBase
    let noDataLabel = UILabel()
    let botLine = UIView()
    
    required init(manager: CIModelItemManager, delegate: CIItemStatsChartDelegate) {
        buttons = delegate.controlNames().map({ CIButton(primaryColor: .whiteColor(), title: $0) })
        chart = delegate.chartType().init()
        noDataLabel.text = String(format: "Not enough data!\n%@", delegate.descriptionForNoData())
        noDataLabel.backgroundColor = manager.colorForItem()
        super.init()
        backgroundColor = manager.colorForItem()
        setupSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupSubviews() {
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
    }
    
    func constrainSubviews() {
        topLine.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
        
        for i in 0..<buttons.count {
            buttons[i].snp_makeConstraints{(make)->Void in
                make.top.equalTo(topLine.snp_bottom).offset(CIConstants.verticalItemSpacing)
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
                make.centerX.equalTo(self.snp_centerX)
            }
            buttons[1].snp_makeConstraints{(make)->Void in
                make.leading.equalTo(buttons[0].snp_trailing).offset(CIConstants.horizontalItemSpacing)
            }
            buttons[2].snp_makeConstraints{(make)->Void in
                make.trailing.equalTo(buttons[0].snp_leading).offset(-CIConstants.horizontalItemSpacing)
            }
            
        }
        
        botLine.snp_makeConstraints{(make)->Void in
            make.bottom.equalTo(self.snp_bottom)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.height.equalTo(1)
        }
        
        chart.snp_makeConstraints{(make)->Void in
            let topGuide = (buttons.count > 0) ? buttons[0] : topLine
            make.top.equalTo(topGuide.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(botLine.snp_top).offset(-CIConstants.verticalItemSpacing)
        }
        
        noDataLabel.snp_makeConstraints {(make)->Void in
            make.leading.greaterThanOrEqualTo(chart.snp_leadingMargin)
            make.trailing.lessThanOrEqualTo(chart.snp_trailingMargin)
            make.centerX.equalTo(chart.snp_centerX)
            make.centerY.equalTo(chart.snp_centerY)
        }
    }
}