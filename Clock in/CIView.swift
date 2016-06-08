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

class CIView: UIView {
    override func addSubview(view: UIView) {
        if view.translatesAutoresizingMaskIntoConstraints {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        super.addSubview(view)
    }
}
