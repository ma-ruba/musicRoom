//
//  SettingsModel.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import FirebaseAnalytics

final class SettingsModel: SettingsModelProtocol {
	var usernameItem: DatabaseItem
	var username: String = ""
	let googleProviderID = "google.com"

	// MARK: Initializzation

	init() {
		guard let uid = Auth.auth().currentUser?.uid else { fatalError(LocalizedStrings.AssertationErrors.noUser.localized) }
		let path = DatabasePath.private.rawValue + DatabasePath.users.rawValue + uid + DatabasePath.slash.rawValue + DatabasePath.username.rawValue
		usernameItem = DatabaseItem(path: path)
		usernameItem.handle = usernameItem.reference.observe(.value) { [weak self] snapshot in
			guard let username = snapshot.value as? String else { return }

			self?.username = username
		}
	}

	deinit {
		guard let handle = usernameItem.handle else { return }

		usernameItem.reference.removeObserver(withHandle: handle)
	}
}
