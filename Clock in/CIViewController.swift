//
//  CIViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIViewController: UIViewController {
    func errorAlert(message:String) {
        let controller = UIAlertController(title: "Error".localized, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay".localized, style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }
}