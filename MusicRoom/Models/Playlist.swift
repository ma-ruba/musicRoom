//
//  Playlist.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Entity that describes playlist in database.
struct Playlist {
	/// Keys for data in object property.
	private enum Key: String {
		case name
		case createdBy
		case userIds
		case tracks
		case type
	}

	var name: String = ""
	var createdBy: String = ""
	var tracks: [PlaylistTrack] = []
	var userIds: [String: Bool] = [:]
	var type: PlaylistType = .public
	var ref: DatabaseReference?

	/// Representation of entity in database.
	var object: [String: String] {
		[
			Key.name.rawValue: name,
			Key.createdBy.rawValue: createdBy,
			Key.type.rawValue: type.name
		]
	}

	var sortedTracks: [PlaylistTrack] {
		tracks.sorted { $0.orderNumber < $1.orderNumber }
	}

	init(name: String, userId: String, type: PlaylistType) {
		self.name = name
		self.userIds = [userId : true]
		self.type = type
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

		if let type = snapshotValue[Key.type.rawValue] as? String {
			switch type {
			case PlaylistType.private.name:
				self.type = .private

			case PlaylistType.public.name:
				self.type = .public

			default:
				break
			}
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
