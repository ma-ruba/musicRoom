//
//  LogPresenter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import GoogleSignIn
//import FBSDKLoginKit
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

	func makeSetups(for view: UIViewController) {
		// Google login stuff
		GIDSignIn.sharedInstance()?.presentingViewController = view
	}

	func forgotPassword() {
		guard let view = view as? LogViewController else { return }

		let forgotViewController = ForgotViewController()
		view.navigationController?.pushViewController(forgotViewController, animated: true)
	}

	func login(with model: LogViewController.AccountInfoModel?) {
		guard let model = model else {
			return view.showAlert(message: locolizedStrings.emptyFieldAlert.localized())
		}

		Auth.auth().signIn(withEmail: model.email, password: model.password) { user, error in
			if error == nil {
				self.openTabBarViewController()
			} else if user == nil {
				self.view.showAlert(message: self.locolizedStrings.noRecordAlert.localized())
			}
		}
	}

	private func openTabBarViewController() {
		guard let logViewController = self.view as? LogViewController else { return }
		let tabBarViewController = TabBarViewController()
		let navigationController = UINavigationController(rootViewController: tabBarViewController)
		navigationController.modalPresentationStyle = .fullScreen
		navigationController.navigationBar.barTintColor = .clear
		navigationController.navigationBar.tintColor = .white
		navigationController.navigationBar.barStyle = .black

//				let viewController = MusicBarViewController()
		logViewController.present(navigationController, animated: true)
	}
}
