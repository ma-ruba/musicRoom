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
		guard let model = model else { return view.showBasicAlert(message: locolizedStrings.emptyFieldAlert.localized()) }

		guard model.password == model.passwordConfirm else {
			return view.showBasicAlert(message: locolizedStrings.passwordAlert.localized())
		}

		view.showSpinner {
			Auth.auth().createUser(withEmail: model.email, password: model.password) { [weak self] user, error in
				self?.view.hideSpinner {
					if error != nil {
						self?.view.showBasicAlert(message: error?.localizedDescription ?? locolizedStrings.sendingErrorAlert.localized())
						self?.view.clearAllTextFieldsInput()
					} else {
						self?.view.showBasicAlert(
							title: locolizedStrings.verifyEmailTitle.localized,
							message: locolizedStrings.verifyEmailMessage.localized
						) { action in
							self?.openLogViewController()
						}
					}
				}
			}
		}
	}

	// MARK: - Private

	private func openLogViewController() {
		let viewController = LogViewController()
		view.navigationController?.popViewController(animated: true)
		view.navigationController?.pushViewController(viewController, animated: true)
	}
}
