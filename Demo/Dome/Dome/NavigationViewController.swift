//
//  NavigationViewController.swift
//  Transitioning
//
//  Created by zZ on 2019/12/6.
//  Copyright © 2019 zZ. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    lazy var customDelegate = NavigationControllerDelegate(navigationController: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = customDelegate
        customDelegate.vcAnimatedTransitioningHandle = { params in
            return VCTransitioning(operation: params.operation)
        }
        let image = UIImage(named: "back_navigationbar")?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = uii
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -20, vertical: 0), for: .default)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        customDelegate.addGesture()
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
//    var interactiveTransition: UIPercentDrivenInteractiveTransition?
//    var gesture: UIGestureRecognizer?
//    weak var navigationController: UINavigationController?
//
//    init(navigationController: UINavigationController) {
//        super.init()
//        self.navigationController = navigationController
//    }
//
//    func addGesture() {
//        let del = navigationController?.interactivePopGestureRecognizer?.delegate
//        let pan = UIPanGestureRecognizer(target: self, action: NSSelectorFromString("handleNavigationTransition:"))
//        pan.delegate = del
//        navigationController?.interactivePopGestureRecognizer?.view?.addGestureRecognizer(pan)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        gesture = pan
//    }
//
//    @objc func handleNavigationTransition(_ gesture: UIScreenEdgePanGestureRecognizer) {
//        guard let view = gesture.view else { return }
//        let translation = gesture.translation(in: view)
//        let progress = translation.x / view.bounds.width
//        if gesture.state == .began {
//            interactiveTransition = UIPercentDrivenInteractiveTransition()
//            navigationController?.popViewController(animated: true)
//        } else if gesture.state == .changed {
//            interactiveTransition?.update(progress)
//        } else if gesture.state == .ended || gesture.state == .cancelled {
//            if progress < 0.4 || gesture.state == .cancelled {
//                interactiveTransition?.cancel()
//            } else {
//                interactiveTransition?.finish()
//            }
//            interactiveTransition = nil
//        }
//    }
//
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactiveTransition
//    }
//
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return VCTransitioning(operation: operation)
//    }
//}
//
class VCTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to), let from = transitionContext.viewController(forKey: .from) else { return }

        let operation = self.operation
        let containerView = transitionContext.containerView
        containerView.addSubview(to.view)
        if operation == .pop {
            containerView.sendSubviewToBack(to.view)
        }

        to.setStatus(.to, operation: operation)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.beginFromCurrentState], animations: {
            to.identity()
            from.setStatus(.from, operation: operation)
        }) { (_) in
            to.identity()
            from.identity()
            if !transitionContext.transitionWasCancelled {
                from.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
    }
}
