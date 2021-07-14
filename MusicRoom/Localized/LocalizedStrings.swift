//
//  LocalizedStrings.swift
//  MusicRoom
//
//  Created by Мария on 07.06.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

enum LocalizedStrings {
	enum Start: LocalizedStringConvertible {
		case logIn
		case signUp
		case welcomeWord
	}

	enum Sign: LocalizedStringConvertible {
		case title
		case emailPlaceholder
		case passwordPlaceholder
		case passwordConfirmationPlaceholder
		case createAccountButtonTitle
		case emptyFieldAlert
		case passwordAlert
		case sendingErrorAlert
		case verifyEmailMessage
		case verifyEmailTitle
	}

	enum Log: LocalizedStringConvertible {
		case title
		case emailPlaceholder
		case passwordPlaceholder
		case logInButtonTitle
		case forgotButtonTitle
		case emptyFieldAlert
		case noRecordAlert
	}

	enum Validator: LocalizedStringConvertible {
		case wrongEmailFormat
	}

	enum Forgot: LocalizedStringConvertible {
		case title
		case emailPlaceholder
		case emailAbsentAlert
		case emailSendingAlert
		case emailSentAlert
		case doneAlertTitle
		case sendButtonTitle
	}

	enum Spinner: LocalizedStringConvertible {
		case title
		case message
	}

	enum Alert: LocalizedStringConvertible {
		case title
		case ok
	}
}
