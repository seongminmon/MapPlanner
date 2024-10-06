//
//  UINavigationController+.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import UIKit

// MARK: - Back Gesture 적용
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
