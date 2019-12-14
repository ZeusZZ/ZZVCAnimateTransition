//
//  UIViewController+ZZVCAnimateTransition.swift
//  ZZVCAnimateTransition
//
//  Created by zZ on 2019/12/14.
//  Copyright © 2019 zZ. All rights reserved.
//

import Foundation
import UIKit

public enum ZZVCStatus {
    case from
    case to
}

extension UIViewController {
    public var sendViewToBackWhenPop: Bool { return true }
    public var toAnimateUntilFromAnimateDone: Bool { return false }

    public func setStatus(_ status: ZZVCStatus, operation: UINavigationController.Operation) {
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

    public func identity() {
        view.transform = .identity
    }
}
