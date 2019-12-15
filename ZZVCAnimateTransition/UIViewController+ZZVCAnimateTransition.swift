//
//  UIViewController+ZZVCAnimateTransition.swift
//  ZZVCAnimateTransition
//
//  Created by zZ on 2019/12/14.
//  Copyright © 2019 zZ. All rights reserved.
//

import Foundation
import UIKit

@objc public
enum ZZVCStatus: Int {
    case from
    case to
}

@objc public
protocol ZZVCAnimateTransition {
    @objc func setStatus(_ status: ZZVCStatus, operation: UINavigationController.Operation)
    @objc func identity()
}

open
class ZZVC: UIViewController {

}

extension UIViewController: ZZVCAnimateTransition {
    var sendViewToBackWhenPop: Bool { return true }
    var toAnimateUntilFromAnimateDone: Bool { return false }

    @objc public func setStatus(_ status: ZZVCStatus, operation: UINavigationController.Operation) {
        let transform = CGAffineTransform.identity
        switch (operation, status) {
        case (.push, .to),
             (.pop, .from):
            view.transform = transform.translatedBy(x: UIScreen.main.bounds.width, y: 0)
        case (.push, .from),
             (.pop, .to):
            view.transform = transform.translatedBy(x: -UIScreen.main.bounds.width * 0.5, y: 0)

        default:
            break
        }
    }

    @objc open func identity() {
        view.transform = .identity
    }

    @objc open func aaa() {
        print("aaaaaaa")
    }
}
