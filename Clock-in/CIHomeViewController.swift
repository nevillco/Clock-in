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
        if(itemManagers.count == 0) {
            view.addItemButton.startFlicker()
        }
        self.view = view
    }
    
    func reloadManagers() {
        self.itemManagers = CIHomeViewController.loadManagers()
        if(itemManagers.count == 0) {
            let view = self.view as! CIHomeView
            view.addItemButton.startFlicker()
        }
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
}

typealias CIHomeViewControllerTargets = CIHomeViewController
extension CIHomeViewControllerTargets {
    func addItemPressed(sender: UIButton) {
        if(itemManagers.count >= CIConstants.maxItems) {
            errorAlert("You've reached the maximum number of items. Delete an item (under Settings) to make some space for a new one.".localized)
            return
        }
        if(itemManagers.count == 0) {
            let view = self.view as! CIHomeView
            view.addItemButton.stopFlicker()
        }
        presentViewController(CIAddItemViewController(), animated: true, completion: nil)
    }
    
    func globalStatsButtonPressed(sender: UIButton) {
        let delegateTypes:[CIGlobalStatsChartDelegate] = [CIGlobalStatsLineChartDelegate(),
                                                          CIGlobalStatsPieChartDelegate(),
                                                          CIGlobalStatsWeekdayChartDelegate(),
                                                          CIGlobalStatsBubbleChartDelegate()]
        var viewControllers:[CIViewController] = delegateTypes.map({ CIGlobalStatsChartViewController(delegate: $0) })
        viewControllers.append(CIGlobalEntriesTableViewController())
        presentViewController(CIStatsPageViewController(viewControllers:viewControllers), animated: true, completion: nil)
    }
    
    func globalSettingsButtonPressed(sender: UIButton) {
        presentViewController(CIGlobalSettingsViewController(), animated: true, completion: nil)
    }
    
    func clockButtonPressed(sender: UIButton) {
        let cell = sender.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        
        cell.clockButton.stopFlicker()
        
        if(manager.item.clockedIn) {
            manager.clockOut()
            cell.resetTimer()
        }
        else {
            manager.clockIn()
            cell.startTimer(manager)
        }
        cell.applyClockedStyle(manager.item.clockedIn, animated: true)
    }
    
    func cancelButtonPressed(sender: UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let manager = itemManagers[cell.tag]
        
        if(manager.item.entries.count == 0) {
            cell.clockButton.startFlicker()
        }
        
        manager.cancelClockIn()
        cell.resetTimer()
        cell.applyClockedStyle(manager.item.clockedIn, animated: true)
    }
    
    func itemSettingsButtonPressed(sender:UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        cell.clockButton.stopFlicker()
        let manager = itemManagers[cell.tag]
        presentViewController(CIItemSettingsViewController(item: manager.item), animated: true, completion: nil)
    }
    
    func itemStatsButtonPressed(sender:UIButton) {
        let cell = sender.superview!.superview as! CIHomeViewCell
        let item = itemManagers[cell.tag].item
        let delegateTypes:[CIItemStatsChartDelegate] = [CIItemStatsLineChartDelegate(itemName: item.name),
                                                        CIItemStatsFilteredBarChartDelegate(itemName: item.name),
                                                        CIItemStatsClockInsByHourChartDelegate(itemName: item.name),
                                                        CIItemStatsClockInsOverIntervalsChartDelegate(itemName: item.name)]
        var viewControllers:[CIViewController] = delegateTypes.map({ CIItemStatsChartViewController(item: item, delegate: $0) })
        viewControllers.appendContentsOf([CIItemStatsTableViewController(item: item), CIItemEntriesTableViewController(item: item)])
        presentViewController(CIStatsPageViewController(viewControllers:viewControllers, item: item), animated: true, completion: nil)
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
        return UIImage(named: "homecell81")?.imageWithRenderingMode(.AlwaysTemplate)
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
        
        cell.applyClockedStyle(manager.item.clockedIn, animated: false)
        if(manager.item.clockedIn) {
            cell.startTimer(manager)
        }
        else {
            cell.resetTimer()
            
            if manager.item.entries.count == 0 {
                cell.clockButton.startFlicker()
            }
            else {
                cell.clockButton.stopFlicker()
            }
        }
        
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