//
//  Validator.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

enum Validator {
	private enum Constants {
		// Расширенная регулярка для почтового адреса
		static var emailRegEx = "^([A-Za-z0-9_-]+\\.)*[A-Za-z0-9_-]+@[A-Za-z0-9_-]{2,63}(\\.[A-Za-z0-9_-]{2,63})*\\.[A-Za-z]{2,63}$"
	}

	/// Валидация строки с почтовым адресом
	///
	/// - Parameter email: строка с почтовым адресом
	/// - Returns: nil, если строка валидна, иначе возвращает строку с ошибкой
	static func validate(email: String?) -> String? {
		guard let email = email else {
			return nil
		}

		let emailPred = NSPredicate(format:"SELF MATCHES %@", Constants.emailRegEx)

		return emailPred.evaluate(with: email) ? nil : LocalizedStrings.Validator.wrongEmailFormat.localized
	}
}
