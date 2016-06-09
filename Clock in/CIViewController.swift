//
//  CIViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIViewController: UIViewController {
    override func viewDidLoad() {
        let view = CIView()
        self.view = view
    }
    
    func errorAlert(message:String) {
        dialogAlert("Error", message: message)
    }
    
    func dialogAlert(title:String, message:String) {
        let controller = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay".localized, style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
        
    }
}