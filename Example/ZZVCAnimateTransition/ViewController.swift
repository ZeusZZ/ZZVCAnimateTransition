//
//  ViewController.swift
//  Transitioning
//
//  Created by zZ on 2019/12/6.
//  Copyright © 2019 zZ. All rights reserved.
//

import UIKit
import ZZVCAnimateTransition

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "\(view.tag)"
//        navigationItem.largeTitleDisplayMode = view.tag == 0 ? .automatic : .never
//        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = view.tag == 0
    }

    func pushToOrPopFrom() {
        switch view.tag {
        case 0:
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        default:
            view.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        }
    }
    func pushFromOrPopTo() {
        switch view.tag {
        case 0:
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        case 1:
            view.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width / 2, y: 0)
        default:
            view.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width, y: 0)
        }
    }

    override func setStatus(_ status: ZZVCStatus, operation: UINavigationController.Operation) {
        switch (operation, status) {
        case (.push, .to),
             (.pop, .from):
            pushToOrPopFrom()
        case (.push, .from),
             (.pop, .to):
            pushFromOrPopTo()

        default:
            break
        }
    }
}

