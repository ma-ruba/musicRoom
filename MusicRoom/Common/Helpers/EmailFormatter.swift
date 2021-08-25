//
//  EmailFormatter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

protocol EmailFormatterDelegate: AnyObject {
	func emailFormatterDidChangeText(_ emailFormatter: EmailFormatterProtocol, email: String?)
	func emailFormatterDidEndEditing(_ emailFormatter: EmailFormatterProtocol, email: String?)
	func emailFormatterDidBeginEditing(_ emailFormatter: EmailFormatterProtocol)
}

// Протокол для класса, который форматирует строку c почтовым адресом
protocol EmailFormatterProtocol: AnyObject, UITextFieldDelegate {
	var delegate: EmailFormatterDelegate? { get set }
}

class EmailFormatter: NSObject, EmailFormatterProtocol {
	weak var delegate: EmailFormatterDelegate?
	let maxSymbolsCount = 100

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let text = ReplaceCharactersHelper.replace(inText: textField.text ?? "", range: range, withCharacters: string)
		let count = text.count
		if count > maxSymbolsCount {
			textField.resignFirstResponder()
			return false
		} else if count == maxSymbolsCount {
			DispatchQueue.main.async {
				textField.resignFirstResponder()
			}
		}
		delegate?.emailFormatterDidChangeText(self, email: text)
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		delegate?.emailFormatterDidEndEditing(self, email: textField.text)
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		delegate?.emailFormatterDidBeginEditing(self)
	}
}
