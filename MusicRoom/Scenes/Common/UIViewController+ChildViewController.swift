//
//  UIViewController+ChildViewController.swift
//  MusicRoom
//
//  Created by Mariia on 14.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

extension UIViewController {
	func add(_ child: UIViewController) {
		addChild(child)
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}

	func removeChild() {
		guard parent != nil else {
			return
		}

		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
