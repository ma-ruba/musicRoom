//
//  Track.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Entity that describes track in database.
class Track {

	/// Keys for data in object property.
	private enum Key: String {
		case name
		case creator
		case id
		case duration
		case type
	}

	var id: String
	var name: String
	var creator: String
	var duration: Int
	var ref: DatabaseReference?

	/// Representation of entity in database.
	var object: [String: Any] {
		[
			Key.id.rawValue: id,
			Key.name.rawValue: name,
			Key.creator.rawValue: creator,
			Key.duration.rawValue: duration
		]
	}

	init(id: String, name: String, creator: String, duration: NSInteger) {
		self.id = id
		self.name = name
		self.creator = creator
		self.duration = duration
	}

	init(dict: [String: Any]) {
		id = dict[Key.id.rawValue] as? String ?? ""
		name = dict[Key.name.rawValue] as? String ?? ""
		creator = dict[Key.creator.rawValue] as? String ?? ""
		duration = dict[Key.duration.rawValue] as? NSInteger ?? 0
	}

	convenience init(snapshot: DataSnapshot) {
		guard let snapshotValue = snapshot.value as? [String: Any] else {
			self.init(dict: [:])
			return
		}

		self.init(dict: snapshotValue)
		ref = snapshot.ref
	}
}
