//
//  UINavigationController+UIGestureRecognizerDelegate.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/09/2020.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
