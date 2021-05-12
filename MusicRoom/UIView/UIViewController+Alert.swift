//
//  UIViewController+Alert.swift
//  MusicRoom
//
//  Created by 18588255 on 19.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func showBasicAlert(title: String = "Error", message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	func showLocationAlert() {
		let alertController = UIAlertController (title: "Location is disabled for the app", message: "Please go to settings and enable it", preferredStyle: .alert)

		let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
			guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
				return
			}

			if UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
					print("Settings opened: \(success)")
				})
			}
		}

		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		alertController.addAction(settingsAction)

		present(alertController, animated: true, completion: nil)
	}
}
