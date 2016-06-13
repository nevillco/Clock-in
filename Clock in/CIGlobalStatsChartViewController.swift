//
//  CIStatsChartViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation

class CIGlobalStatsChartViewController: CIViewController {
    let delegate:CIStatsChartDelegate
    required init(delegate: CIStatsChartDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIGlobalStatsChartView(buttonNames: delegate.controlNames())
        addTargets(view)
        addDelegates(view)
        self.view = view
    }
}

private extension CIGlobalStatsChartViewController {
    func addTargets(view: CIGlobalStatsChartView) {
    }
    
    func addDelegates(view: CIGlobalStatsChartView) {
    }
}
