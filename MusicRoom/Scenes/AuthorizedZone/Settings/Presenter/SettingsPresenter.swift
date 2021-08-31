//
//  SettingsPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import GoogleSignIn

final class SettingsPresenter: SettingsPresenterProtocol {
	unowned private var view: SettingsViewProtocol
	private var model: SettingsModel?

	var numberOfSections: Int {
		SettingsSectionType.allCases.count
	}

	var googleProviderID: String {
		model?.googleProviderID ?? ""
	}

	var username: String {
		get {
			model?.username ?? ""
		}
		set {
			model?.username = newValue
		}
	}

	// MARK: Initializzation

	init(view: SettingsViewProtocol) {
		self.view = view

		model = SettingsModel()
	}

	// MARK: - SettingsPresenterProtocol

	func loginToGoogle() {
		GIDSignIn.sharedInstance().signIn()
	}

	func submitUsername() {
		model?.saveUsername()
	}

	func logout() {
		do {
//			GIDSignIn.sharedInstance().signOut()
//			LoginManager().logOut()
			try Auth.auth().signOut()
			DeezerSession.sharedInstance.clearMusic()
			DeezerSession.sharedInstance.deezerConnect?.logout()
			Analytics.logEvent("logging_out", parameters: Log.defaultInfo())
		} catch {
			view.showBasicAlert(title: LocalizedStrings.Settings.logoutError.localized, message: error.localizedDescription)
		}
	}

	func manageFriends() {
		let friendsViewController = FriendsViewController()
		view.navigationController?.pushViewController(friendsViewController, animated: true)
	}

	func loginToDeezer() {
		DeezerSession.sharedInstance.deezerConnect?.authorize([
			DeezerConnectPermissionBasicAccess,
			DeezerConnectPermissionManageLibrary,
			DeezerConnectPermissionOfflineAccess
		])
	}
}
