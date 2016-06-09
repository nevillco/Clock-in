//
//  CIHomeViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class CIHomeViewController: CIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIHomeView()
        addDelegates(view)
        addTargets(view)
        self.view = view
    }
}

private extension CIHomeViewController {
    func addDelegates(view: CIHomeView) {
        view.table.emptyDataSetSource = self
        view.table.emptyDataSetDelegate = self
        view.table.delegate = self
        view.table.dataSource = self
    }
    
    func addTargets(view: CIHomeView) {
        view.addItemButton.addTarget(self, action: #selector(addItemPressed(_:)), forControlEvents: .TouchUpInside)
        view.globalStatsButton.addTarget(self, action: #selector(globalStatsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.globalSettingsButton.addTarget(self, action: #selector(globalSettingsButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
}

typealias CIHomeViewControllerTargets = CIHomeViewController
extension CIHomeViewControllerTargets {
    func addItemPressed(sender: UIButton) {
        presentViewController(CIAddItemViewController(), animated: true, completion: nil)
    }
    
    func globalStatsButtonPressed(sender: UIButton) {
        
    }
    
    func globalSettingsButtonPressed(sender: UIButton) {
        
    }
}

extension CIHomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let titleText = "nothing yet".localized
        let textRange = NSRange(location: 0, length: titleText.characters.count)
        let attributedText = NSMutableAttributedString(string: titleText.localized)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetTitleFont, range: textRange)
        return attributedText
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let bodyText = "Click the \"add item\" button above to start adding things to track!"
        let textRange = NSRange(location: 0, length: bodyText.characters.count)
        let attributedText = NSMutableAttributedString(string: bodyText.localized)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetBodyFont, range: textRange)
        
        let coloredRange = (bodyText as NSString).rangeOfString("\"add item\"")
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.CIBlue, range: coloredRange)
        return attributedText
    }
}

extension CIHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}