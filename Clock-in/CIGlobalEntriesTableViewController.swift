//
//  CIGlobalEntriesTableViewController.swift
//  Clock-in
//
//  Created by Connor Neville on 6/22/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CIGlobalEntriesTableViewController: CIViewController {
    let data: [(CIModelItem, CIModelEntry)] = CIGlobalEntriesTableViewController.loadData()
    let dateFormatter = NSDateFormatter()
    
    override init() {
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

private extension CIGlobalEntriesTableViewController {
    static func loadData() -> [(CIModelItem, CIModelEntry)] {
        var pairs:[(CIModelItem, CIModelEntry)] = []
        let realm = try! Realm()
        let items = realm.objects(CIModelItem.self)
        for item in items {
            for entry in item.entries {
                pairs.append((item, entry))
            }
        }
        
        return pairs.sort({ $0.1.startDate.compare($1.1.startDate) == .OrderedDescending })
    }
    
    func addDelegates(view: UITableView) {
        view.registerClass(CIStatsViewCell.self, forCellReuseIdentifier: .CIStatsCellReuseIdentifier)
        view.delegate = self
        view.dataSource = self
    }
}

extension CIGlobalEntriesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CIStatsCellReuseIdentifier) as! CIStatsViewCell
        
        let (item, entry) = data[indexPath.row]
        
        cell.infoLabel.text = String(format: "%@ - %@", item.name.uppercaseString, dateFormatter.stringFromDate(entry.startDate).uppercaseString)
        cell.dataLabel.text = NSDate.longStringForInterval(Int(entry.time)).uppercaseString
        cell.tag = indexPath.row
        
        cell.backgroundColor = UIColor.colorForItem(item)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CIConstants.statsCellRowHeight()
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CIConstants.statsCellHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CIStatsCellHeader(color: UIColor.whiteColor())
        
        header.label.text = "Most Recent Clock Ins"
        header.label.textColor = .CIBlack
        
        return header
    }
}
