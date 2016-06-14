//
//  CIStatsChartViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation

class CIItemStatsChartViewController: CIViewController {
    let delegate:CIItemStatsChartDelegate
    let item: CIModelItem
    required init(item: CIModelItem, delegate: CIItemStatsChartDelegate) {
        self.item = item
        self.delegate = delegate
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIItemStatsChartView(item: item, delegate: delegate)
        delegate.styleChart(view.chart)
        addTargets(view)
        self.view = view
        chartButtonPressed(view.buttons[0])
    }
    
    func chartButtonPressed(sender: UIButton) {
        let view = self.view as! CIItemStatsChartView
        let index = view.buttons.indexOf(sender as! CIButton)!
        for i in 0..<view.buttons.count {
            view.buttons[i].permanentHighlight = (i == index)
        }
        delegate.loadChartData(view.chart, selectedButtonIndex:index)
    }
}

private extension CIItemStatsChartViewController {
    func addTargets(view: CIItemStatsChartView) {
        for button in view.buttons {
            button.addTarget(self, action: #selector(chartButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
}
