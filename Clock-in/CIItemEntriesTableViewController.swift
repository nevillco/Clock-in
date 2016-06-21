//
//  CIItemEntriesTableViewController.swift
//  Clock-in
//
//  Created by Connor Neville on 6/21/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIItemEntriesTableViewController: CIViewController {
    let item: CIModelItem
    let entries: [CIModelEntry]
    let dateFormatter = NSDateFormatter()
    
    required init(item:CIModelItem) {
        self.item = item
        self.entries = item.entries.reverse()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .clearColor()
        view.separatorStyle = .None
        addDelegates(view)
        self.view = view
    }
}

private extension CIItemEntriesTableViewController {
    func addDelegates(view: UITableView) {
        view.registerClass(CIStatsViewCell.self, forCellReuseIdentifier: .CIStatsCellReuseIdentifier)
        view.delegate = self
        view.dataSource = self
    }
}

extension CIItemEntriesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CIStatsCellReuseIdentifier) as! CIStatsViewCell
        
        let entry = entries[indexPath.row]
        
        cell.infoLabel.text = dateFormatter.stringFromDate(entry.startDate).uppercaseString
        cell.dataLabel.text = NSDate.longStringForInterval(Int(entry.time)).uppercaseString
        cell.tag = indexPath.row
        
        let backgroundColor = (UIColor.colorForItem(item) == UIColor.CIBlack) ? UIColor.whiteColor() : UIColor.blackColor()
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = backgroundColor.colorWithAlphaComponent(0.2)
        }
        else {
            cell.backgroundColor = .clearColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CIConstants.statsCellRowHeight
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CIConstants.statsCellHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CIStatsCellHeader(color: UIColor.colorForItem(item))
        
        header.label.text = "Most Recent Clock Ins"
        
        return header
    }
}
