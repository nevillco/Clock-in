//
//  CIGlobalSettingsViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/11/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Foundation
import RealmSwift

class CIGlobalSettingsViewController: CIViewController {
    var notificationsOn:Bool = false
    var intervals:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIGlobalSettingsView()
        addTargets(view)
        addDelegates(view)
        loadDefaults()
        self.view = view
        updateNotificationsButton()
    }
    
    func loadDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.intervals = defaults.objectForKey(String.CIDefaultNotificationIntervals) as! [Int]
        self.notificationsOn = defaults.boolForKey(String.CIDefaultNotificationsOn)
    }
}

private extension CIGlobalSettingsViewController {
    func addTargets(view: CIGlobalSettingsView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.notificationsButton.addTarget(self, action: #selector(notificationsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.deleteButton.addTarget(self, action: #selector(deleteItemsButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func addDelegates(view: CIGlobalSettingsView) {
        view.table.delegate = self
        view.table.dataSource = self
        view.table.registerClass(CISettingsViewCell.self, forCellReuseIdentifier: .CISettingsCellReuseIdentifier)
    }
    
    func saveDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(intervals, forKey: String.CIDefaultNotificationIntervals)
        defaults.setBool(notificationsOn, forKey: String.CIDefaultNotificationsOn)
    }
    
    func updateNotificationsButton() {
        let view = self.view as! CIGlobalSettingsView
        if(notificationsOn) {
            view.notificationsButton.setTitle("notifications on".localized, forState: .Normal)
        }
        else {
            view.notificationsButton.setTitle("notifications off".localized, forState: .Normal)
        }
        
        view.notificationsButton.permanentHighlight = notificationsOn
    }
}

typealias CIGlobalSettingsViewControllerTargets = CIGlobalSettingsViewController
extension CIGlobalSettingsViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CISettingsViewCell
        intervals.removeAtIndex(cell.tag)
        
        let view = self.view as! CIGlobalSettingsView
        view.table.deleteRowsAtIndexPaths([NSIndexPath(forRow: cell.tag, inSection: 0)], withRowAnimation: .Middle)
        view.table.reloadEmptyDataSet()
        view.table.reloadData()
        
        saveDefaults()
    }
    
    func addButtonPressed(sender: UIButton) {
        presentViewController(CIAddNotificationViewController(), animated: true, completion: nil)
    }
    
    func notificationsButtonPressed(sender: UIButton) {
        let delegate = UIApplication.sharedApplication().delegate as! CIAppDelegate
        if(!delegate.notificationsEnabledInSettings()) {
            errorAlert("You have notifications disabled in your device's Settings. Please enable them to use this page.")
            return
        }
        notificationsOn = !notificationsOn
        saveDefaults()
        let view = self.view as! CIGlobalSettingsView
        view.table.reloadData()
        view.table.reloadEmptyDataSet()
        saveDefaults()
        updateNotificationsButton()
    }
    
    func deleteItemsButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Are You Sure?".localized, message: "Clicking confirm will permanently remove all of your items, including their data.".localized, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm".localized, style: .Destructive, handler: {_ in
            let presenter = self.presentingViewController as! CIHomeViewController
            let presenterView = presenter.view as! CIHomeView
            let realm = try! Realm()
            try! realm.write{
                realm.deleteAll()
            }
            self.dismissViewControllerAnimated(true, completion: {_ in
                presenter.reloadManagers()
                presenterView.table.reloadData()
                presenterView.table.reloadEmptyDataSet()
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension CIGlobalSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsOn ? intervals.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CISettingsCellReuseIdentifier) as! CISettingsViewCell
        let item = intervals[indexPath.row]
        
        cell.label.text = NSDate.longStringForInterval(item)
        cell.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CIConstants.settingsCellRowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (!notificationsOn) ? 0 : CIConstants.settingsHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(!notificationsOn) { return nil }
        
        let header = CISettingsViewHeader()
        
        let max = CIConstants.maxNotifications
        let current = intervals.count
        
        let text = String(format: "%d notifications allowed\n%d remaining", max, (max - current))
        let attributedText = NSMutableAttributedString(string: text)
        
        let textRange = NSRange(location: 0, length: text.characters.count)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: textRange)
        let defaultFontRange = (text as NSString).rangeOfString(String(format: "%d notifications allowed", max))
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIDefaultBodyFont, range: defaultFontRange)
        let boldFontRange = (text as NSString).rangeOfString(String(format: "%d remaining", (max - current)))
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIBoldBodyFont, range: boldFontRange)
        
        header.label.attributedText = attributedText
        
        header.addButton.addTarget(self, action: #selector(addButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        return header
    }
}