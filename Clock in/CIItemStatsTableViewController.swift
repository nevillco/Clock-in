//
//  CIItemStatsTableViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/16/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIItemStatsTableViewController: CIViewController {
    var item: CIModelItem
    let sectionLabels: [String]
    let rowLabels: [[String]]
    var data: [[String]]?
    
    required init(item:CIModelItem) {
        self.item = item
        self.sectionLabels = ["Clocked Time", "Days Clocked", "Streaks"]
        self.rowLabels = [
            ["ALL TIME", "LAST 30 DAYS", "LAST 7 DAYS", "LAST 24 HOURS"],
            ["CREATED DATE", "DAYS SINCE CREATION", "DAYS CLOCKED IN", "% OF DAYS CLOCKED IN"],
            ["CURRENT STREAK", "LONGEST STREAK"]]
        super.init()
        loadData()
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

private extension CIItemStatsTableViewController {
    func addDelegates(view: UITableView) {
        view.registerClass(CIStatsViewCell.self, forCellReuseIdentifier: .CIStatsCellReuseIdentifier)
        view.delegate = self
        view.dataSource = self
    }
    
    func loadData(){
        self.data = [clockedTime(), daysClocked(), streaks()]
    }
    
    func clockedTime() -> [String] {
        var totals:[Double] = [0, 0, 0, 0]
        let day:Double = 60*60*24
        var maxIntervalDifferences = [-1,30*day,7*day,day]
        for entry in item.entries {
            let now = NSDate()
            let entryDate = entry.startDate
            totals[0] += entry.time
            for i in 1...3 {
                if now.timeIntervalSinceDate(entryDate) <= maxIntervalDifferences[i] {
                    totals[i] += entry.time
                }
            }
        }
        return totals.map({ NSDate.longStringForInterval(Int($0)).uppercaseString })
    }
    
    func daysClocked() -> [String] {
        let createdDate = item.createDate
        let day:Double = 60*60*24
        let daysSinceCreation = max(1, Int(NSDate().timeIntervalSinceDate(createdDate) / day))
        let daysClockedIn = Array(Set(item.entries.map({ $0.startDate.roundToDay() }))).count
        let percentDaysClockedIn = String(format:"%d%%", Int(round(100 * Double(daysClockedIn) / Double(daysSinceCreation))))
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        return [formatter.stringFromDate(createdDate), String(daysSinceCreation), String(daysClockedIn), percentDaysClockedIn]
    }
    
    func streaks() -> [String] {
        var currentStreak = 0
        var maxStreak = 0
        let createdDate = item.createDate.roundToDay()
        var currentDate = createdDate
        let endDate = NSDate().roundToDay()
        let daysClockedIn = Array(Set(item.entries.map({ $0.startDate.roundToDay() })))
        while endDate.timeIntervalSinceDate(currentDate) >= 0 {
            if daysClockedIn.contains(currentDate) {
                currentStreak += 1
            }
            else {
                maxStreak = max(maxStreak, currentStreak)
                currentStreak = 0
            }
            currentDate = currentDate.advancedByDays(1)
        }
        maxStreak = max(maxStreak, currentStreak)
        return [currentStreak, maxStreak].map({ String(format: "%d day%@", $0, $0 == 1 ? "" : "s").uppercaseString })
    }
}

extension CIItemStatsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data![section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.CIStatsCellReuseIdentifier) as! CIStatsViewCell
        
        cell.infoLabel.text = rowLabels[indexPath.section][indexPath.row]
        cell.dataLabel.text = data![indexPath.section][indexPath.row]
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
        
        header.label.text = sectionLabels[section]
        
        return header
    }
}
