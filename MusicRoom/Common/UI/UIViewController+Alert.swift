//
//  UIViewController+Alert.swift
//  MusicRoom
//
//  Created by Mariia on 19.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func showBasicAlert(title: String = LocalizedStrings.Alert.title.localized, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: LocalizedStrings.Alert.ok.localized.uppercased(), style: .default, handler: handler))
		present(alert, animated: true, completion: nil)
	}
}
