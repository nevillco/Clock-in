//
//  CIView.swift
//  Clock in
//
//  UIView extension for any overrides common to all UIViews in project
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import SnapKit

class CIView: UIView {
    let dismisser = UIButton()
    
    override func addSubview(view: UIView) {
        if view.translatesAutoresizingMaskIntoConstraints {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        super.addSubview(view)
    }
    
    init() {
        super.init(frame: CGRectZero)
        setupDismisser()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupDismisser() {
        dismisser.setTitle("", forState: .Normal)
        dismisser.backgroundColor = .clearColor()
        addSubview(dismisser)
        sendSubviewToBack(dismisser)
        dismisser.snp_makeConstraints { (make)->Void in
            make.edges.equalTo(self)
        }
        dismisser.addTarget(self, action: #selector(dismisserPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func dismisserPressed(sender:UIButton) {
        endEditing(true)
    }
}

class CITableViewCell: UITableViewCell {
    let dismisser = UIButton()
    
    override func addSubview(view: UIView) {
        if view.translatesAutoresizingMaskIntoConstraints {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        super.addSubview(view)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDismisser()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    func setupDismisser() {
        dismisser.setTitle("", forState: .Normal)
        dismisser.backgroundColor = .clearColor()
        addSubview(dismisser)
        sendSubviewToBack(dismisser)
        dismisser.snp_makeConstraints { (make)->Void in
            make.edges.equalTo(self)
        }
        dismisser.addTarget(self, action: #selector(dismisserPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func dismisserPressed(sender:UIButton) {
        endEditing(true)
    }
}

class CIViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(CIError.CoderInitUnimplementedString)
    }
    
    override func viewDidLoad() {
        let view = CIView()
        self.view = view
    }
    
    func errorAlert(message:String) {
        dialogAlert("Error", message: message)
    }
    
    func errorAlert(message:String, handler:((handler:UIAlertAction)->Void)) {
        dialogAlert("Error", message: message, handler: handler)
    }
    
    func dialogAlert(title:String, message:String) {
        let controller = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay".localized, style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func dialogAlert(title:String, message:String, handler:((handler:UIAlertAction)->Void)) {
        let controller = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay".localized, style: .Default, handler: handler)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }
}
