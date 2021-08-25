//
//  LogPresenter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import GoogleSignIn
import Firebase

final class LogPresenter: LogPresenterProtocol {
	unowned private var view: LogViewProtocol
	private var model: LogModel?

	private let locolizedStrings: LocalizedStrings.Log.Type = LocalizedStrings.Log.self

	init(view: LogViewProtocol) {
		self.view = view

		model = nil
	}

	// MARK: - LogPresenterProtocol

	func makeSetups() {
		// Google login stuff
		GIDSignIn.sharedInstance()?.presentingViewController = view.navigationController
	}

	func forgotPassword() {
		let forgotViewController = ForgotViewController()
		view.navigationController?.pushViewController(forgotViewController, animated: true)
	}

	func login(with model: LogViewController.AccountInfoModel?) {
		guard let model = model else {
			return view.showBasicAlert(message: locolizedStrings.emptyFieldAlert.localized())
		}

		view.showSpinner {
			Auth.auth().signIn(withEmail: model.email, password: model.password) { [weak self] user, error in
				guard let self = self else { return }
				self.view.hideSpinner {
					if error == nil {
						self.openTabBarViewController()
					} else {
						self.view.showBasicAlert(message: error?.localizedDescription ?? self.locolizedStrings.noRecordAlert.localized)
					}
				}
			}
		}
	}

	func loginWithGoogle() {
		openTabBarViewController()
	}

	private func openTabBarViewController() {
		guard let logViewController = self.view as? LogViewController else { return }
		let tabBarViewController = TabBarViewController()
		tabBarViewController.modalPresentationStyle = .overFullScreen

		logViewController.present(tabBarViewController, animated: true)
	}
}
