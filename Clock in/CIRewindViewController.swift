//
//  CIRewindViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/14/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class CIRewindViewController: CIViewController {
    var manager: CIModelItemManager
    
    required init(manager: CIModelItemManager) {
        self.manager = manager
        let view = CIRewindView(backgroundColor: manager.colorForItem())
        view.startTimer(manager.lastClockIn!)
        super.init()
        self.view = view
        addTargets(view)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension CIRewindViewController {
    func addTargets(view: CIRewindView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
}

typealias CIRewindViewControllerTargets = CIRewindViewController
extension CIRewindViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        (view as! CIRewindView).resetTimer()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goButtonPressed(sender: UIButton) {
        let view = self.view as! CIRewindView
        let interval = view.picker.countDownDuration
        let maximumInterval = manager.currentClockTime()
        if interval > maximumInterval {
            errorAlert("You haven't been clocked in that long yet!")
        }
        else {
            manager.rewindTime += interval
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}