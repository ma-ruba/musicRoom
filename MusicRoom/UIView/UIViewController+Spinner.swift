//
//  UIViewController+Spinner.swift
//  MusicRoom
//
//  Created by Mariia on 06.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

typealias VoidCallback = () -> Void

private final class SaveAlertHandler {
	static var alertHandle: UIAlertController?

	private init() { }

	static func get() -> UIAlertController? {
		return alertHandle
	}

	static func clear() {
		alertHandle = nil
	}

	static func set(_ handle: UIAlertController?) {
		alertHandle = handle
	}
}

protocol Spinner {
	func showSpinner(_ completion: VoidCallback?)
	func hideSpinner(_ completion: VoidCallback?)
}

extension UIViewController: Spinner {

	func showSpinner(_ completion: VoidCallback?) {
		let locolizedStrings = LocalizedStrings.Spinner.self
		let title = locolizedStrings.title.localized
		let message = locolizedStrings.message.localized
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

		SaveAlertHandler.set(alertController)

		let spinner = UIActivityIndicatorView(style: .large)
		spinner.color = .black
		spinner.startAnimating()

		alertController.view.addSubview(spinner)

		spinner.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		present(alertController, animated: true, completion: completion)

//		spinner.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
	}

	func hideSpinner(_ completion: VoidCallback?) {
		guard let controller = SaveAlertHandler.get() else { return }

		SaveAlertHandler.clear()
		controller.dismiss(animated: true, completion: completion)
	}
}
