//
//  NavigationControllerDelegate.swift
//  ZZVCAnimateTransition
//
//  Created by zZ on 2019/12/14.
//  Copyright © 2019 zZ. All rights reserved.
//

import UIKit

public
typealias VCAnimatedTransitioningParams = (navigationController: UINavigationController, operation: UINavigationController.Operation, fromVC: UIViewController, toVC: UIViewController)
public
typealias VCAnimatedTransitioningHandle = (VCAnimatedTransitioningParams) -> UIViewControllerAnimatedTransitioning?

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    var gesture: UIPanGestureRecognizer?
    var isCurveLinear = false
    weak var navigationController: UINavigationController?
    weak var interactivePopGestureRecognizer: UIGestureRecognizer?

    public var vcAnimatedTransitioningHandle: VCAnimatedTransitioningHandle?
    public convenience init(navigationController: UINavigationController?) {
        self.init()
        self.navigationController = navigationController
    }

    public func addGesture() {
        guard let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer else { return }
        self.interactivePopGestureRecognizer = interactivePopGestureRecognizer
        let pan = UIPanGestureRecognizer(target: self, action: NSSelectorFromString("handleNavigationTransition:"))
        pan.delegate = self
        interactivePopGestureRecognizer.view?.addGestureRecognizer(pan)
        gesture = pan
        enableGesture()
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gesture, gestureRecognizer == gesture else { return false }
        if (navigationController?.viewControllers.count ?? 0) <= 1 {
            return false
        }

        // Ignore pan gesture when the navigation controller is currently in transition.
        if let isTransitioning = navigationController?.value(forKey: "_isTransitioning") as? Bool, isTransitioning {
                return false
        }

        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = gesture.translation(in: gesture.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1 : -1
        if (translation.x * multiplier) <= 0 {
            return false
        }

        return true
    }

    public func enableGesture() {
        interactivePopGestureRecognizer?.isEnabled = false
        gesture?.isEnabled = true
    }

    public func disableGesture() {
        interactivePopGestureRecognizer?.isEnabled = true
        gesture?.isEnabled = false
    }

    @objc func handleNavigationTransition(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view)
        let progress = max(0, translation.x) / (view.bounds.width)
        if gesture.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            isCurveLinear = true
            navigationController?.popViewController(animated: true)
        } else if gesture.state == .changed {
            interactiveTransition?.update(progress)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if progress < 0.4 || gesture.state == .cancelled {
                interactiveTransition?.cancel()
            } else {
                interactiveTransition?.finish()
            }
            interactiveTransition = nil
        }
    }

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        defer { isCurveLinear = false }
        return vcAnimatedTransitioningHandle?((navigationController, operation, fromVC, toVC))
    }
}

