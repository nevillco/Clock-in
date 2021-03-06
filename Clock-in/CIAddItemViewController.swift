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
    var availableColors = CIModelItemManager.CIAvailableColors()
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
        view.colorCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: .CIDefaultCollectionCellReuseIdentifier)
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

extension CIAddItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableColors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.CIDefaultCollectionCellReuseIdentifier, forIndexPath: indexPath)
        
        let row:Int = indexPath.item
        cell.backgroundColor = availableColors[row]
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 4.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CIConstants.colorCollectionCellSize()
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
            presenter.viewDidAppear(false)
            presenterView.table.insertRowsAtIndexPaths(self.indexPathsToReloadOnDismiss(), withRowAnimation: .Middle)
            presenterView.table.reloadEmptyDataSet()
        })
    }
    
    func goButtonPressed(sender: UIButton) throws {
        let view = self.view as! CIAddItemView
        let name = view.nameField.text!
        if let error = CIModelItemCreator.validate(name) {
            errorAlert(error)
            return
        }
        else {
            CIModelItemCreator.createItem(name, color: selectedColor)
        }
        itemsAdded += 1
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
            let view = self.view as! CIAddItemView
            view.successMessage()
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