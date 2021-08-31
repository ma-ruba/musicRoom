//
//  SettingsSectionType.swift
//  MusicRoom
//
//  Created by Mariia on 30.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Types of sections in tableView in SettingsView.
enum SettingsSectionType: Int, CaseIterable {

	// Int value corresponds to the section index

	/// Accounts section.
	case accounts = 0

	/// Friends section.
	case friends

	/// Logout section.
	case logout

	/// Name of the section.
	var name: String {
		switch self {
			case .accounts:
				return LocalizedStrings.Settings.accountsSectionTitle.localized.uppercased()

			case .friends:
				return LocalizedStrings.Settings.friendsSectionTitle.localized.uppercased()

			case .logout:
				return LocalizedStrings.Settings.logoutSectionTitle.localized.uppercased()
		}
	}
}
