//
//  CIAddNotificationViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Foundation

class CIAddNotificationViewController: CIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIAddNotificationView()
        addTargets(view)
        self.view = view
    }
}

private extension CIAddNotificationViewController {
    func addTargets(view: CIAddNotificationView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
}

typealias CIAddNotificationViewControllerTargets = CIAddNotificationViewController
extension CIAddNotificationViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goButtonPressed(sender: UIButton) {
        let view = self.view as! CIAddNotificationView
        let interval = view.picker.countDownDuration
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var defaultIntervals = defaults.objectForKey(.CIDefaultNotificationIntervals) as! [NSTimeInterval]
        
        if defaultIntervals.contains(interval) {
            errorAlert("This time is already in your default notifications.".localized)
        }
        else {
            let presenter = presentingViewController as! CIGlobalSettingsViewController
            let presenterView = presenter.view as! CIGlobalSettingsView
            defaultIntervals.append(interval)
            let newIntervals = defaultIntervals.sort()
            defaults.setObject(newIntervals, forKey: .CIDefaultNotificationIntervals)
            dismissViewControllerAnimated(true, completion: {
                presenter.dialogAlert("Success".localized, message: "This time is now included in your default notifications.")
                presenter.loadDefaults()
                presenterView.table.reloadEmptyDataSet()
                presenterView.table.reloadData()
            })
        }
    }
}