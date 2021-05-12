//
//  EventTrack.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

class EventTrack: Track {
	let trackKey: String
	var vote: Int
	var voters: [String: Bool]?

	init(dict: [String: AnyObject], trackKey: String) {
		self.trackKey = trackKey
		self.vote = dict["vote"] as? NSInteger ?? 0
		self.voters = dict["voters"] as? [String: Bool] ?? [:]

		super.init(dict: dict)
	}

	override func toDict() -> [String : Any] {
		var dict = super.toDict()

		dict["vote"] = vote
		dict["voters"] = voters

		return dict
	}
}
