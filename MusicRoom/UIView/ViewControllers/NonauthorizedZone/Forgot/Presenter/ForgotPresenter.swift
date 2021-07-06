//
//  ForgotPresenter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class ForgotPresenter: ForgotPresenterProtocol {
	unowned private var view: ForgotViewProtocol
	private var model: ForgotModel?

	private let locolizedStrings: LocalizedStrings.Forgot.Type = LocalizedStrings.Forgot.self

	init(view: ForgotViewProtocol) {
		self.view = view

		model = nil
	}

	// MARK: - ForgotPresenterProtocol

	func send(email: String?) {
		guard let email = email else {
			return view.showBasicAlert(message: locolizedStrings.emailAbsentAlert.localized)
		}

		view.showSpinner {
			Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
				guard let self = self else { return }
				self.view.hideSpinner {
					if error != nil {
						self.view.showBasicAlert(message: error?.localizedDescription ?? self.locolizedStrings.emailSendingAlert.localized)
					} else {
						self.view.showBasicAlert(title: self.locolizedStrings.doneAlertTitle.localized, message: self.locolizedStrings.emailSentAlert.localized)
					}
				}
			}
		}
		view.dismiss(animated: true, completion: nil)
	}
}
