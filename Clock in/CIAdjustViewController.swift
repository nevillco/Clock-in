//
//  CIAdjustViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/14/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class CIAdjustViewController: CIViewController {
    var manager: CIModelItemManager
    var selectedButton:UIButton
    
    required init(manager: CIModelItemManager) {
        self.manager = manager
        let view = CIAdjustView(backgroundColor: manager.colorForItem())
        view.startTimer(manager)
        self.selectedButton = view.rewindButton
        super.init()
        self.view = view
        addTargets(view)
        topButtonPressed(view.rewindButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension CIAdjustViewController {
    func addTargets(view: CIAdjustView) {
        view.rewindButton.addTarget(self, action: #selector(topButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.forwardButton.addTarget(self, action: #selector(topButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
}

typealias CIAdjustViewControllerTargets = CIAdjustViewController
extension CIAdjustViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        (view as! CIAdjustView).resetTimer()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func topButtonPressed(sender: UIButton) {
        let view = self.view as! CIAdjustView
        for button in [view.rewindButton, view.forwardButton] {
            button.permanentHighlight = (button == sender)
        }
        selectedButton = sender
    }
    
    func goButtonPressed(sender: UIButton) {
        let view = self.view as! CIAdjustView
        let interval = view.picker.countDownDuration
        if selectedButton == view.rewindButton {
            let maximumInterval = manager.currentClockTime()
            if interval > maximumInterval {
                errorAlert("You haven't been clocked in that long yet!")
            }
            else {
                manager.adjustTime -= interval
                dismissViewControllerAnimated(true, completion: nil)
                view.resetTimer()
            }
        }
        else {
            manager.adjustTime += interval
            dismissViewControllerAnimated(true, completion: nil)
            view.resetTimer()
        }
    }
}