//
//  CIItemSettingsViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Foundation
import RealmSwift

class CIItemSettingsViewController: CIViewController {
    var notificationsOn = false
    let item:CIModelItem
    
    required init(item:CIModelItem) {
        self.item = item
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIItemSettingsView(name: item.name)
        loadDefaults()
        addTargets(view)
        addDelegates(view)
        self.view = view
    }
}

private extension CIItemSettingsViewController {
    func addTargets(view: CIItemSettingsView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.deleteButton.addTarget(self, action: #selector(deleteItemButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func addDelegates(view: CIItemSettingsView) {
        view.table.emptyDataSetSource = self
        view.table.emptyDataSetDelegate = self
        view.table.delegate = self
        view.table.dataSource = self
        view.table.registerClass(CISettingsViewCell.self, forCellReuseIdentifier: .CISettingsCellReuseIdentifier)
    }
    
    func saveRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func loadDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        notificationsOn = defaults.boolForKey(.CIDefaultNotificationsOn)
    }
}

typealias CIItemSettingsViewControllerTargets = CIItemSettingsViewController
extension CIItemSettingsViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CISettingsViewCell
        let realm = try! Realm()
        try! realm.write {
            item.notificationIntervals.removeAtIndex(cell.tag)
        }
        
        let view = self.view as! CIItemSettingsView
        view.table.deleteRowsAtIndexPaths([NSIndexPath(forRow: cell.tag, inSection: 0)], withRowAnimation: .Middle)
        view.table.reloadEmptyDataSet()
        view.table.reloadData()
    }
    
    func addButtonPressed(sender: UIButton) {
        presentViewController(CIAddNotificationViewController(), animated: true, completion: nil)
    }
    
    func deleteItemButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Are You Sure?".localized, message: "Clicking confirm will permanently remove this item, including its data.".localized, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm".localized, style: .Destructive, handler: {_ in
            //to write
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension CIItemSettingsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let titleText = notificationsOn ? "nothing yet".localized : "turned off".localized
        let textRange = NSRange(location: 0, length: titleText.characters.count)
        let attributedText = NSMutableAttributedString(string: titleText.localized)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetTitleFont, range: textRange)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: textRange)
        return attributedText
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let delegate = UIApplication.sharedApplication().delegate as! CIAppDelegate
        let bodyText:String
        if(!delegate.notificationsEnabledInSettings()) {
            bodyText = "Your device's settings do not give us permissions to send notifications.".localized
        }
        else if notificationsOn {
            bodyText = "Click the \"add\" button above to add a notification time!".localized
        }
        else {
            bodyText = "Tap the button at the top to turn on notifications.".localized
        }
        let textRange = NSRange(location: 0, length: bodyText.characters.count)
        let attributedText = NSMutableAttributedString(string: bodyText.localized)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetBodyFont, range: textRange)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: textRange)
        
        if notificationsOn {
            let coloredRange = (bodyText as NSString).rangeOfString("\"add item\"")
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.CIBlue, range: coloredRange)
        }
        return attributedText
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "clockIcon50")?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return .whiteColor()
    }
}

extension CIItemSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsOn ? item.notificationIntervals.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CISettingsCellReuseIdentifier) as! CISettingsViewCell
        let interval = item.notificationIntervals[indexPath.row]
        
        cell.label.text = NSDate.longStringForInterval(Int(interval.value))
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
        let current = item.notificationIntervals.count
        
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