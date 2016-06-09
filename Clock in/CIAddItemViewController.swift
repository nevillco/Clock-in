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
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIAddItemView()
        addTargets(view)
        addDelegates(view)
        view.nameField.becomeFirstResponder()
        self.view = view
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
    }
}

typealias CIAddItemViewControllerTargets = CIAddItemViewController
extension CIAddItemViewControllerTargets {
    func backButtonPressed(sender: UIButton) {
        view.endEditing(true)
        let presenterView = presentingViewController!.view as! CIHomeView
        dismissViewControllerAnimated(true, completion: {
            presenterView.table.reloadData()
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
        createItem(name)
        view.nameField.text = ""
        view.endEditing(true)
        dialogAlert("Success", message: "Your new item has been created. Feel free to add another, or go back to the home page.")
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
    
    func createItem(name:String) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(CIModelItem.self, value: ["name": name], update: false)
        }
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