//
//  SignPresenter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Firebase

final class SignPresenter: SignPresenterProtocol {
	unowned private var view: SignViewProtocol
	private let model: SignModel?

	init(view: SignViewProtocol) {
		self.view = view

		model = nil
	}

	// MARK: - SignPresenterProtocol

	func createAccount(with model: SignViewController.AccountInfoModel?) {
		let locolizedStrings = LocalizedStrings.Sign.self
		guard let model = model else { return view.showAlert(message: locolizedStrings.emptyFieldAlert.localized()) }

		guard model.password == model.passwordConfirm else {
			view.clearAllTextFieldsInput()
			return view.showAlert(message: locolizedStrings.passwordAlert.localized())
		}

		Auth.auth().createUser(withEmail: model.email, password: model.password) { user, error in
			if error != nil {
				print(error.debugDescription)
				self.view.showAlert(message: error?.localizedDescription ?? locolizedStrings.sendingErrorAlert.localized())
				self.view.clearAllTextFieldsInput()
			}
		}
	}

}
