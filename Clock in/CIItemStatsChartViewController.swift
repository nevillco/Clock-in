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
    required init(delegate: CIItemStatsChartDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIItemStatsChartView(buttonNames: delegate.controlNames(), chartType: delegate.chartType().self)
        addTargets(view)
        addDelegates(view)
        self.view = view
    }
    
    func chartButtonPressed(sender: UIButton) {
        let view = self.view as! CIItemStatsChartView
        let index = view.buttons.indexOf(sender as! CIButton)!
        delegate.loadChartData(view.chart, selectedButtonIndex:index)
    }
}

private extension CIItemStatsChartViewController {
    func addTargets(view: CIItemStatsChartView) {
        for button in view.buttons {
            button.addTarget(self, action: #selector(chartButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func addDelegates(view: CIItemStatsChartView) {
    }
}
