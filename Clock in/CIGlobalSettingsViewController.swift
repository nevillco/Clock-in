//
//  CIGlobalSettingsViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/11/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import RealmSwift

class CIGlobalSettingsViewController: CIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIGlobalSettingsView()
        addTargets(view)
        self.view = view
    }
}

private extension CIGlobalSettingsViewController {
    func addTargets(view: CIGlobalSettingsView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
}

typealias CIGlobalSettingsViewControllerTargets = CIGlobalSettingsViewController
extension CIGlobalSettingsViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}