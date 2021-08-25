//
//  Playlist.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

struct Playlist {

	enum Key: String {
		case name
		case createdBy
		case userIds
		case tracks
	}

	var name: String = ""
	var createdBy: String = ""
	var tracks: [PlaylistTrack]?
	var userIds: [String: Bool]?
	var ref: DatabaseReference?

	var publicObject: [String: String] {
		[
			Key.name.rawValue: name,
			Key.createdBy.rawValue: createdBy,
		]
	}

	var privateObject: Any {
		[
			Key.name.rawValue: name,
			Key.createdBy.rawValue: createdBy,
			Key.userIds.rawValue: userIds as Any,
		]
	}

	var sortedTracks: [PlaylistTrack] {
		tracks?.sorted { $0.orderNumber < $1.orderNumber } ?? []
	}

	init(name: String, userId: String) {
		self.name = name
		self.userIds = [userId : true]
		createdBy = userId
	}

	init(snapshot: DataSnapshot) {
		guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return }

		if let name = snapshotValue[Key.name.rawValue] as? String {
			self.name = name
		}

		if let createdBy = snapshotValue[Key.createdBy.rawValue] as? String {
			self.createdBy = createdBy
		}

		let trackDicts = snapshotValue[Key.tracks.rawValue] as? [String: [String: AnyObject]]
		if let trackDicts = trackDicts {
			tracks = trackDicts.map { element in PlaylistTrack(dict: element.value, trackKey: element.key) }
		}

		if let userIds = snapshotValue[Key.userIds.rawValue] as? [String:Bool] {
			self.userIds = userIds
		}

		ref = snapshot.ref
	}
}
