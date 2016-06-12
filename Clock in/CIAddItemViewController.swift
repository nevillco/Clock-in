//
//  CIAddItemViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import RealmSwift

class CIAddItemViewController: CIViewController {
    let cellReuseIdentifier = "ColorChoice"
    var availableColors = UIColor.CIAvailableColors()
    var selectedColor = UIColor.clearColor()
    var itemsAdded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIAddItemView()
        addTargets(view)
        addDelegates(view)
        self.view = view
        collectionView(view.colorCollection, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
    }
}

private extension CIAddItemViewController {
    func addTargets(view: CIAddItemView) {
        view.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.nameField.addTarget(self, action: #selector(nameFieldChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    func addDelegates(view: CIAddItemView) {
        view.nameField.delegate = self
        view.colorCollection.delegate = self
        view.colorCollection.dataSource = self
        view.colorCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
}

extension CIAddItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableColors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        let row:Int = indexPath.item
        cell.backgroundColor = availableColors[row]
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 4.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(50, 50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row:Int = indexPath.item
        let color = availableColors[row]
        self.view.backgroundColor = color
        selectedColor = color
    }
}

typealias CIAddItemViewControllerTargets = CIAddItemViewController
extension CIAddItemViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        let presenter = presentingViewController as! CIHomeViewController
        let presenterView = presenter.view as! CIHomeView
        dismissViewControllerAnimated(true, completion: {
            presenter.reloadManagers()
            presenterView.table.insertRowsAtIndexPaths(self.indexPathsToReloadOnDismiss(), withRowAnimation: .Middle)
            presenterView.table.reloadEmptyDataSet()
        })
    }
    
    func goButtonPressed(sender: UIButton) throws {
        let view = self.view as! CIAddItemView
        let name = view.nameField.text!
        let chars = name.characters.count
        if chars == 0 {
            errorAlert("Please enter an item name.".localized)
            return
        }
        if chars > CIConstants.itemMaxChars {
            errorAlert(String(format: "Item names can be at most %d characters.", CIConstants.itemMaxChars).localized)
            return
        }
        if itemNameExists(name) {
            errorAlert("You already have an item with this name. Please try another.".localized)
            return
        }
        createItem(name, color: selectedColor)
        view.nameField.text = ""
        nameFieldChanged(view.nameField)
        view.endEditing(true)
        availableColors.removeAtIndex(availableColors.indexOf(selectedColor)!)
        if availableColors.count == 0 {
            let presenter = presentingViewController as! CIHomeViewController
            let presenterView = presentingViewController!.view as! CIHomeView
            dismissViewControllerAnimated(true, completion: {
                presenter.dialogAlert("Success".localized, message: "Your new item has been created. You're now at the maximum number of items.".localized)
                presenter.reloadManagers()
                presenterView.table.insertRowsAtIndexPaths(self.indexPathsToReloadOnDismiss(), withRowAnimation: .Middle)
                presenterView.table.reloadEmptyDataSet()
            })
        }
        else {
            view.colorCollection.reloadData()
            collectionView(view.colorCollection, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            dialogAlert("Success".localized, message: "Your new item has been created. Feel free to add another, or go back to the home page.".localized)
        }
    }
    
    func nameFieldChanged(sender: UITextField) {
        let chars = sender.text!.characters.count
        let charsRemaining = CIConstants.itemMaxChars - chars
        let view = self.view as! CIAddItemView
        view.updateCharsLabel(charsRemaining)
        view.checkNameFieldAlignment()
    }
}

typealias CIAddItemViewControllerRealm = CIAddItemViewController
extension CIAddItemViewControllerRealm {
    func itemNameExists(name: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name == %@", name)
        let itemsWithName = realm.objects(CIModelItem.self).filter(predicate)
        return itemsWithName.count > 0
    }
    
    func createItem(name:String, color:UIColor) {
        let realm = try! Realm()
        let item = CIModelItem()
        item.name = name
        item.createDate = NSDate()
        item.colorIndex = UIColor.CIColorPalette.indexOf(color)!
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let intervals = defaults.objectForKey(.CIDefaultNotificationIntervals) as! [NSTimeInterval]
        intervals.forEach{
            let doubleObj = CIDoubleObject()
            doubleObj.value = $0
            item.notificationIntervals.append(doubleObj)
        }
        
        try! realm.write {
            realm.add(item, update: false)
        }
        itemsAdded += 1
    }
    
    func indexPathsToReloadOnDismiss() -> [NSIndexPath] {
        let realm = try! Realm()
        let numItems = realm.objects(CIModelItem.self).count
        var indexPaths = [NSIndexPath]()
        for i in 0..<itemsAdded {
            indexPaths.append(NSIndexPath(forRow: numItems - (i + 1), inSection: 0))
        }
        return indexPaths
    }
}

extension CIAddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let view = self.view as! CIAddItemView
        do {
            try self.goButtonPressed(view.goButton)
        }
        catch let error {
            print(error)
        }
        return true
    }
}