//
//  MAPageViewController.swift
//  MAPageViewController
//
//  Created by Mike on 6/19/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit
import SnapKit

class CIStatsPageViewController: UIViewController {
    let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
    
    let item:CIModelItem?
    var viewControllers: [CIViewController] = []
    var currentIndex = 0
    
    let titleLabel = UILabel()
    let backButton = UIButton()
    let pageControl: UIPageControl = UIPageControl()
    
    init(viewControllers: [CIViewController], item: CIModelItem) {
        self.viewControllers = viewControllers
        self.item = item
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.colorForItem(item)
        setupSubviews()
    }
    
    init(viewControllers: [CIViewController]) {
        self.viewControllers = viewControllers
        self.item = nil
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        setupPageViewController()
        addTargets()
    }
    
    func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self;
        
        let startY = titleLabel.frame.origin.y + titleLabel.frame.height + CIConstants.verticalItemSpacing
        pageViewController.view.frame = CGRectMake(0, startY, self.view.frame.width, (self.view.frame.height - startY - CIConstants.pageControlHeight))
        
        pageViewController.setViewControllers([viewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.bringSubviewToFront(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(pageViewController.view.frame), self.view.bounds.size.width, CIConstants.pageControlHeight)
        pageControl.numberOfPages = viewControllers.count;
        self.view.addSubview(pageControl)
    }
    
    private func addTargets() {
        pageControl.addTarget(self, action: #selector(pageControlPressed(_:)), forControlEvents: .ValueChanged)
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func backButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pageControlPressed(sender: UIPageControl) {
        let destination = viewControllers[sender.currentPage]
        if sender.currentPage > currentIndex {
            pageViewController.setViewControllers([destination], direction: .Forward, animated: true, completion: nil)
        }
        else {
            pageViewController.setViewControllers([destination], direction: .Reverse, animated: true, completion: nil)
        }
        currentIndex = sender.currentPage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(pageViewController.view.frame), self.view.bounds.size.width, CIConstants.pageControlHeight)
    }
}

extension CIStatsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if(currentIndex == viewControllers.count - 1) {
            return nil
        }
        return viewControllers[currentIndex + 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?  {
        if(currentIndex == 0) {
            return nil
        }
        return viewControllers[currentIndex - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        let newViewController = pageViewController.viewControllers![0] as! CIViewController
        currentIndex = viewControllers.indexOf(newViewController)!
        pageControl.currentPage = viewControllers.indexOf(newViewController)!
    }
}

typealias CIStatsPageViewStyle = CIStatsPageViewController
extension CIStatsPageViewStyle {
    func setupSubviews() {
        titleLabel.text = item?.name ?? "all stats".localized
        titleLabel.font = UIFont.CIDefaultTitleFont()
        titleLabel.textColor = (item == nil) ? UIColor.blackColor() : UIColor.whiteColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        view.addSubview(titleLabel)
        
        backButton.setTitle("‹go back".localized, forState: .Normal)
        backButton.titleLabel!.font = UIFont.CILargeTextButtonFont()
        backButton.setTitleColor((item == nil) ? UIColor.blackColor() : UIColor.whiteColor(), forState: .Normal)
        backButton.setTitleColor(.CIGray, forState: .Highlighted)
        view.addSubview(backButton)
        
        if item == nil {
            pageControl.pageIndicatorTintColor = UIColor.CIBlack
            pageControl.currentPageIndicatorTintColor = UIColor.CIBlack.colorWithAlphaComponent(0.5)
        }
        else {
            pageControl.pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        }
    }
    
    override func viewWillLayoutSubviews() {
        backButton.snp_remakeConstraints {(make)->Void in
            make.leading.equalTo(self.view.snp_leadingMargin)
            make.baseline.equalTo(titleLabel.snp_baseline)
        }
        
        titleLabel.snp_remakeConstraints {(make)->Void in
            make.leading.greaterThanOrEqualTo(backButton.snp_trailing).offset(CIConstants.horizontalItemSpacing)
            make.trailing.equalTo(self.view.snp_trailingMargin)
            make.topMargin.equalTo(self.view).offset(CIConstants.paddingFromTop())
        }
        
        pageViewController.view.snp_remakeConstraints{(make)->Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(CIConstants.verticalItemSpacing)
            make.leading.equalTo(self.view.snp_leading)
            make.trailing.equalTo(self.view.snp_trailing)
            make.bottom.equalTo(pageControl.snp_top)
        }
        
        pageControl.snp_remakeConstraints{(make)->Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottomMargin)
            make.height.equalTo(CIConstants.pageControlHeight)
        }
    }
}