//
//  LocalizedStringConvertible.swift
//  MusicRoom
//
//  Created by Мария on 07.06.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

protocol LocalizedStringConvertible {
	var key: String { get }
	var localized: String { get }
	func localized(withArgs args: CVarArg...) -> String
}

extension LocalizedStringConvertible {

	var key: String {
		String(describing: type(of: self)) + "_" + String(describing: self)
	}

	var localized: String {
		NSLocalizedString(key, comment: "")
	}

	func localized(withArgs args: CVarArg...) -> String {
		return String(format: localized, locale: Locale.current, arguments: args)
	}
}
