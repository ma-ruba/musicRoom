//
//  UIViewController+KeyboardScrollable.swift
//  MusicRoom
//
//  Created by Мария on 07.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardScrollable: AnyObject {
	var scrollViewContainer: UIScrollView? { get }

	func registerForKeyboardNotifications()
	func unregisterFromKeyboardNotifications()
}

extension UIViewController: KeyboardScrollable {
	var scrollViewContainer: UIScrollView? {
		view.subviews.first { $0 is UIScrollView } as? UIScrollView
	}

	func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillChangeFrame(notification:)),
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
	}

	func unregisterFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(
			self,
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
	}

	@objc func keyboardWillChangeFrame(from beginFrame: CGRect, to endFrame: CGRect) {
		guard let scrollView = scrollViewContainer else { return }

		let beginHeight = beginFrame.origin.y
		let endHeight = endFrame.origin.y
		var inset = scrollView.contentInset
		inset.bottom += beginHeight - endHeight
		scrollView.contentInset = inset
	}

	@objc private func keyboardWillChangeFrame(notification: NSNotification) {
		guard let userInfo = notification.userInfo,
			let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
			let endFrame =  userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
		else {
			return
		}

		keyboardWillChangeFrame(from: beginFrame, to: endFrame)
	}
}
