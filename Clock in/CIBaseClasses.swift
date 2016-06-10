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
