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
    var renameField = UITextField()
    
    required init(item:CIModelItem) {
        self.item = item
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIItemSettingsView(name: item.name, backgroundColor: UIColor.colorForItem(item))
        loadDefaults()
        addTargets(view)
        addDelegates(view)
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let view = self.view as! CIItemSettingsView
        view.colorCollection.collectionViewLayout.invalidateLayout()
        view.colorCollection.layoutSubviews()
    }
}

private extension CIItemSettingsViewController {
    func addTargets(view: CIItemSettingsView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.renameButton.addTarget(self, action: #selector(renameButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.deleteButton.addTarget(self, action: #selector(deleteItemButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func addDelegates(view: CIItemSettingsView) {
        view.table.emptyDataSetSource = self
        view.table.emptyDataSetDelegate = self
        view.table.delegate = self
        view.table.dataSource = self
        view.table.registerClass(CISettingsViewCell.self, forCellReuseIdentifier: .CISettingsCellReuseIdentifier)
        
        view.colorCollection.delegate = self
        view.colorCollection.dataSource = self
        view.colorCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: .CIDefaultCollectionCellReuseIdentifier)
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
        let presenter = presentingViewController as! CIHomeViewController
        let presenterView = presenter.view as! CIHomeView
        
        dismissViewControllerAnimated(true, completion: {
            presenter.reloadManagers()
            presenterView.table.reloadData()
            presenterView.table.reloadEmptyDataSet()
        })
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
        let newController = CIAddNotificationViewController()
        newController.item = item
        presentViewController(newController, animated: true, completion: nil)
    }
    
    func deleteItemButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Are You Sure?".localized, message: "Clicking confirm will permanently remove this item, including its data.".localized, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm".localized, style: .Destructive, handler: {_ in
            let presenter = self.presentingViewController as! CIHomeViewController
            let presenterView = presenter.view as! CIHomeView
            let realm = try! Realm()
            try! realm.write{
                realm.delete(self.item)
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
    
    func renameButtonPressed(sender:UIButton) {
        let alertController = UIAlertController(title: "Rename".localized, message: String(format:"Enter a new name for your item. It must be between 1-%d characters and cannot be in use.", CIConstants.itemMaxChars).localized, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "new name"
            textField.autocapitalizationType = .Words
            self.renameField = textField
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm".localized, style: .Default, handler: {_ in
            let name = self.renameField.text!
            if let error = CIModelItemCreator.validate(name) {
                self.errorAlert(error, handler: {_ in
                    let view = self.view as! CIItemSettingsView
                    self.renameButtonPressed(view.renameButton)
                })
            }
            else {
                CIModelItemCreator.rename(self.item, toName: name)
                self.dialogAlert("Success".localized, message: "Your item has been renamed.".localized)
                let view = self.view as! CIItemSettingsView
                view.titleLabel.text = name
            }
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
        header.backgroundColor = UIColor.colorForItem(item)
        
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

extension CIItemSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let colorCount = CIModelItemManager.CIAvailableColors().count
        return colorCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.CIDefaultCollectionCellReuseIdentifier, forIndexPath: indexPath)
        
        let row:Int = indexPath.item
        let availableColors = CIModelItemManager.CIAvailableColors()
        cell.backgroundColor = availableColors[row]
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 4.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let isLandscape = UIDevice.currentDevice().orientation.isLandscape
        return isLandscape ? CIConstants.colorCollectionLandscapeCellSize : CIConstants.colorCollectionCellSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row:Int = indexPath.item
        let availableColors = CIModelItemManager.CIAvailableColors()
        let color = availableColors[row]
        let colorIndex = UIColor.CIColorPalette.indexOf(color)!
        
        let realm = try! Realm()
        try! realm.write {
            item.colorIndex = colorIndex
        }
        
        let view = self.view as! CIItemSettingsView
        view.backgroundColor = color
        view.table.reloadData()
        collectionView.reloadData()
    }
}