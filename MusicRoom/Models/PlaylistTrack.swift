//
//  PlaylistTrack.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

class PlaylistTrack: Track {
	let trackKey: String
	let orderNumber: Double

	init(dict: [String: AnyObject], trackKey: String) {
		self.trackKey = trackKey
		self.orderNumber = dict["orderNumber"] as? Double ?? 0

		super.init(dict: dict)
	}
}
