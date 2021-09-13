//
//  SettingsPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import GoogleSignIn
import FirebaseAnalytics

final class SettingsPresenter: SettingsPresenterProtocol {
	unowned private var view: SettingsViewProtocol
	private var model: SettingsModel

	var numberOfSections: Int {
		SettingsSectionType.allCases.count
	}

	var googleProviderID: String {
		model.googleProviderID
	}

	var username: String {
		get {
			model.username
		}
		set {
			model.username = newValue
		}
	}
	
	private var handler: TabBarViewProtocol

	// MARK: Initializzation

	init(view: SettingsViewProtocol, handler: TabBarViewProtocol) {
		self.view = view
		self.handler = handler

		model = SettingsModel()
	}

	// MARK: - SettingsPresenterProtocol

	func loginToGoogle() {
		GIDSignIn.sharedInstance().signIn()
	}

	// TODO: Add checker for username duplicate.
	func submitUsername() {
		guard !username.isEmpty else { return }

		model.usernameItem.reference.setValue(username) { error, _ in
			guard error == nil else { return print(error?.localizedDescription) }
		}
	}

	func logout() {
		do {
			try Auth.auth().signOut()
			GIDSignIn.sharedInstance().signOut()
			DeezerManager.sharedInstance.stop()
			DeezerManager.sharedInstance.deezerConnect?.logout()
			handler.dismiss()
		} catch {
			view.showBasicAlert(title: LocalizedStrings.Settings.logoutError.localized, message: error.localizedDescription)
		}
	}

	func manageFriends() {
		let friendsViewController = FriendsViewController()
		view.navigationController?.pushViewController(friendsViewController, animated: true)
	}

	func loginToDeezer() {
		DeezerManager.sharedInstance.deezerConnect?.authorize([
			DeezerConnectPermissionBasicAccess,
			DeezerConnectPermissionManageLibrary,
			DeezerConnectPermissionOfflineAccess,
			DeezerConnectPermissionListeningHistory,
			DeezerConnectPermissionDeleteLibrary
		])
	}
}
