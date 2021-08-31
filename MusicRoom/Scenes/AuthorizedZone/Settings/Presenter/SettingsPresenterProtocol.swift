//
//  SettingsPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Inteface for SettingsPresenter.
protocol SettingsPresenterProtocol {

	/// Property that describes number of sections in the tableView in SettingsView.
	var numberOfSections: Int { get }

	/// Google provider ID.
	var googleProviderID: String { get }

	/// Username.
	var username: String { get set }

	/// Method logs out.
	func logout()

	/// Method opens  friends management page.
	func manageFriends()

	/// Method performs logging to Deezer.
	func loginToDeezer()

	/// Method saves a new username to database.
	func submitUsername()

	// Method opens page with logging to Google.
	func loginToGoogle()
}
