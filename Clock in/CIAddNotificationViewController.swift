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
    }
}

typealias CIAddNotificationViewControllerTargets = CIAddNotificationViewController
extension CIAddNotificationViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}