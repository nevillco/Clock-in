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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goButtonPressed(sender: UIButton) throws {
        let view = self.view as! CIAddItemView
        guard let text = view.nameField.text else {
            throw CIErrorType.StringNotFoundError
        }
        if text.characters.count == 0 {
            errorAlert("Please enter an item name.".localized)
            return
        }
        else if text.characters.count > CIConstants.itemMaxChars {
            errorAlert(String(format: "Item names can be at most %d characters.", CIConstants.itemMaxChars).localized)
            return
        }
        print(text)
    }
    
    func nameFieldChanged(sender: UITextField) {
        let chars = sender.text!.characters.count
        let charsRemaining = CIConstants.itemMaxChars - chars
        let view = self.view as! CIAddItemView
        view.updateCharsLabel(charsRemaining)
    }
}

extension CIAddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let view = self.view as! CIAddItemView
        view.endEditing(true)
        try! goButtonPressed(view.goButton)
        return true
    }
}