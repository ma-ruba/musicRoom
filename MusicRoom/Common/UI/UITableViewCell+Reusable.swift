//
//  UITableViewCell+Reusable.swift
//  MusicRoom
//
//  Created by 18588255 on 07.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
	static var reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {
	static var reuseIdentifier: String {
		"\(self)"
	}
}

extension UITableView {
	func registerReusable<T: Reusable>(cellClass: T.Type) {
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UITableViewCell>(withClass reusableClass: T.Type, for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: reusableClass.reuseIdentifier, for: indexPath) as? T
		else {
			fatalError("dequeueReusableCell(withClass:for:)")
		}
		return cell
	}
}
