//
//  PlaylistTrack.swift
//  MusicRoom
//
//  Created by Mariia on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Entity that describes track in playlist context.
final class PlaylistTrack: Track {

	/// Keys for data in object property.
	private enum Key: String {
		case orderNumber
	}

	let trackKey: String
	let orderNumber: Int
	
	// MARK: Initialization

	init(dict: [String: Any], trackKey: String) {
		self.trackKey = trackKey
		self.orderNumber = dict[Key.orderNumber.rawValue] as? Int ?? 0

		super.init(dict: dict)
	}
}
