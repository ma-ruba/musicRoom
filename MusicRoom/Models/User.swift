//
//  User.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Entity that describes user in database.
struct User {

	/// Keys for data in object property.
	private enum Key: String {
		case playlists
		case friends
	}

	let playlists: [String: String]
	let friends: [String: String]

	init(dict: [String: Any]) {
		playlists = dict[Key.playlists.rawValue] as? [String: String] ?? [:]
		friends = dict[Key.friends.rawValue] as? [String: String] ?? [:]
	}

	init(snapshot: DataSnapshot) {
		guard let snapshotValue = snapshot.value as? [String: Any] else {
			self.init(dict: [:])
			return
		}

		self.init(dict: snapshotValue)
	}

}
