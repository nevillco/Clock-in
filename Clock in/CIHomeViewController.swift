//
//  CIHomeViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class CIHomeViewController: CIViewController {
    var itemManagers:[CIModelItemManager] = CIHomeViewController.loadManagers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIHomeView()
        addDelegates(view)
        addTargets(view)
        self.view = view
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertIfNecessary(false)
    }
    
    func reloadManagers() {
        self.itemManagers = CIHomeViewController.loadManagers()
    }
    
    static func loadManagers() -> [CIModelItemManager] {
        let realm = try! Realm()
        let modelItems = realm.objects(CIModelItem.self)
        return modelItems.map({ CIModelItemManager(item: $0) })
    }
}

private extension CIHomeViewController {
    func addDelegates(view: CIHomeView) {
        view.table.emptyDataSetSource = self
        view.table.emptyDataSetDelegate = self
        view.table.delegate = self
        view.table.dataSource = self
        view.table.registerClass(CIHomeViewCell.self, forCellReuseIdentifier: .CIHomeCellReuseIdentifier)
    }
    
    func addTargets(view: CIHomeView) {
        view.addItemButton.addTarget(self, action: #selector(addItemPressed(_:)), forControlEvents: .TouchUpInside)
        view.globalStatsButton.addTarget(self, action: #selector(globalStatsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.globalSettingsButton.addTarget(self, action: #selector(globalSettingsButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func presentAlertIfNecessary(hasClockedOut: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let wasForcedToClockOut:Bool = defaults.boolForKey(.CIDefaultAlertForcedClockOut)
        if wasForcedToClockOut {
            dialogAlert("Whoops...".localized, message: "The app terminated while an item was clocked in. We automatically clocked out for you. Make sure you don't terminate the app while clocked in (Leaving it in the background is fine)!".localized)
            defaults.setBool(false, forKey: .CIDefaultAlertForcedClockOut)
            return
        }
    }
}

typealias CIHomeViewControllerTargets = CIHomeViewController
extension CIHomeViewControllerTargets {
    func addItemPressed(sender: UIButton) {
        if(itemManagers.count >= CIConstants.maxItems) {
            errorAlert("You've reached the maximum number of items. Delete an item (under Settings) to make some space for a new one.".localized)
            return
        }
        presentViewController(CIAddItemViewController(), animated: true, completion: nil)
    }
    
    func globalStatsButtonPressed(sender: UIButton) {
    }
    
    func globalSettingsButtonPressed(sender: UIButton) {
        presentViewController(CIGlobalSettingsViewController(), animated: true, completion: nil)
    }
    
    func clockButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        
        if(manager.clockedIn) {
            manager.clockOut()
            cell.resetTimer()
            presentAlertIfNecessary(true)
        }
        else {
            manager.clockIn()
            cell.startTimer(manager)
        }
        cell.applyClockedStyle(manager.clockedIn)
    }
    
    func cancelButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        
        manager.cancelClockIn()
        cell.resetTimer()
        cell.applyClockedStyle(manager.clockedIn)
    }
    
    func itemSettingsButtonPressed(sender:UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        presentViewController(CIItemSettingsViewController(manager: manager), animated: true, completion: nil)
    }
    
    func itemStatsButtonPressed(sender:UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        let delegateTypes:[CIItemStatsChartDelegate] = [CIItemLineChartDelegate(item: manager.item),
                                                        CIItemWeekdayBarChartDelegate(item: manager.item),
                                                        CIItemClockInsOverIntervalsDelegate(item: manager.item),
                                                        CIItemClockInsByHourDelegate(item: manager.item)]
        let viewControllers = delegateTypes.map({ CIItemStatsChartViewController(manager: manager, delegate: $0) })
        presentViewController(CIStatsPageViewController(viewControllers:viewControllers, manager: manager), animated: true, completion: nil)
    }
    
    func adjustButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        presentViewController(CIAdjustViewController(manager: manager), animated: true, completion: nil)
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
        let bodyText = "Click the \"add item\" button above to start adding things to track!".localized
        let textRange = NSRange(location: 0, length: bodyText.characters.count)
        let attributedText = NSMutableAttributedString(string: bodyText.localized)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.CIEmptyDataSetBodyFont, range: textRange)
        
        let coloredRange = (bodyText as NSString).rangeOfString("\"add item\"")
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.CIBlue, range: coloredRange)
        return attributedText
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "clockIcon50")?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    func imageTintColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return .CIBlue
    }
}

extension CIHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemManagers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CIHomeCellReuseIdentifier) as! CIHomeViewCell
        let manager = itemManagers[indexPath.row]
        let color = UIColor.colorForItem(manager.item)
        
        cell.primaryColor = color
        cell.nameLabel.text = manager.item.name
        cell.tag = indexPath.row
        
        cell.clockButton.addTarget(self, action: #selector(clockButtonPressed(_:)), forControlEvents: .TouchUpInside)
        cell.settingsButton.addTarget(self, action: #selector(itemSettingsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        cell.statsButton.addTarget(self, action: #selector(itemStatsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        cell.adjustButton.addTarget(self, action: #selector(adjustButtonPressed(_:)), forControlEvents: .TouchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CIConstants.homeCellRowHeight
    }
}