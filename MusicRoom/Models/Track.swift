//
//  Track.swift
//  MusicRoom
//
//  Created by Mariia on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Entity that describes track in database.
class Track: Equatable {

	/// Keys for data in object property.
	private enum Key: String {
		case name
		case creator
		case id
		case duration
		case type
		case deezerId
	}

	var id: String
	var name: String
	var creator: String
	var duration: Int
	var deezerId: String

	/// Representation of entity in database.
	var object: [String: Any] {
		[
			Key.id.rawValue: id,
			Key.name.rawValue: name,
			Key.creator.rawValue: creator,
			Key.duration.rawValue: duration,
			Key.deezerId.rawValue: deezerId
		]
	}
	
	// MARK: Initialization

	init(
		id: String,
		name: String,
		creator: String,
		duration: NSInteger,
		deezerId: String
	) {
		self.id = id
		self.name = name
		self.creator = creator
		self.duration = duration
		self.deezerId = deezerId
	}

	init(dict: [String: Any]) {
		id = dict[Key.id.rawValue] as? String ?? ""
		name = dict[Key.name.rawValue] as? String ?? ""
		creator = dict[Key.creator.rawValue] as? String ?? ""
		duration = dict[Key.duration.rawValue] as? NSInteger ?? 0
		deezerId = dict[Key.deezerId.rawValue] as? String ?? ""
	}

	convenience init(snapshot: DataSnapshot) {
		guard let snapshotValue = snapshot.value as? [String: Any] else {
			self.init(dict: [:])
			return
		}

		self.init(dict: snapshotValue)
	}

	// MARK: - Equatable

	static func == (lhs: Track, rhs: Track) -> Bool {
		return lhs.id == rhs.id && lhs.name == rhs.name && lhs.creator == rhs.creator
			&& lhs.duration == rhs.duration && lhs.deezerId == rhs.deezerId
	}
}
