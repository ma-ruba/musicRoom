//
//  SettingsModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for  SettingsModel.
protocol SettingsModelProtocol {

	/// Username.
	var username: String { get set }

	/// Google provider ID.
	var googleProviderID: String { get }

	/// Method saves a new username to database.
	func saveUsername()
}
