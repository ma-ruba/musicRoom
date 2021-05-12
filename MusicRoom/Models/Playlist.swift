//
//  Playlist.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

struct Playlist {

	var name: String
	var createdBy: String
	var tracks: [PlaylistTrack]?
	var userIds: [String: Bool]?
	var ref: DatabaseReference?

	init(name: String, userId: String) {
		self.name = name
		self.createdBy = userId
		self.userIds = [userId : true]
	}

	init(snapshot: DataSnapshot) {
		self.name = ""
		self.createdBy = ""

		if let snapshotValue = snapshot.value as? [String: AnyObject] {
			if let name = snapshotValue["name"] as? String {
				self.name = name
			}
			if let createdBy = snapshotValue["createdBy"] as? String {
				self.createdBy = createdBy
			}

			let trackDicts = snapshotValue["tracks"] as? [String: [String: AnyObject]]
			if let trackDicts = trackDicts {
				self.tracks = trackDicts.map { element in PlaylistTrack(dict: element.value, trackKey: element.key) }
			}

			if let userIds = snapshotValue["userIds"] as? [String:Bool] {
				self.userIds = userIds
			}
			ref = snapshot.ref
		}
	}

	func sortedTracks() -> [PlaylistTrack] {
		return self.tracks?.sorted { $0.orderNumber < $1.orderNumber } ?? []
	}

	func toPrivateObject() -> Any {
		return [
			"name": name,
			"createdBy": createdBy,
			"userIds" : userIds as Any,
		]
	}

	func toPublicObject() -> Any {
		return [
			"name": name,
			"createdBy": createdBy,
		]
	}
}
