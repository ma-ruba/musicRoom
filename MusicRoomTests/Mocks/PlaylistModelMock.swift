//
//  PlaylistModelMock.swift
//  MusicRoomTests
//
//  Created by 18588255 on 17.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import XCTest
@testable import MusicRoom

final class PlaylistModelMock: PlaylistModelProtocol {
	var privatePlaylistItem: DatabaseItem {
		let item = DatabaseItem(path: "test1")
		let firstPlaylist = [
			Playlist.Key.id.rawValue: "1",
			Playlist.Key.name.rawValue: "Tets1",
			Playlist.Key.createdBy.rawValue: currentUserId
		]
		let secondPlaylist = [
			Playlist.Key.id.rawValue: "2",
			Playlist.Key.name.rawValue: "Tets2",
			Playlist.Key.createdBy.rawValue: currentUserId
		]
		let reference = MockDatabaseReference(with: [firstPlaylist, secondPlaylist])
		item.setReference(reference)

		return item
	}

	var publicPlaylistItem: DatabaseItem {
		let item = DatabaseItem(path: "test2")
		let playlist = [
			Playlist.Key.id.rawValue: "3",
			Playlist.Key.name.rawValue: "Tets3",
			Playlist.Key.createdBy.rawValue: currentUserId
		]
		let reference = MockDatabaseReference(with: [playlist])
		item.setReference(reference)

		return item
	}

	var currentUserId = "Test"

	var updateView: (() -> Void)?
	var privatePlaylist: [Playlist] = []
	var publicPlaylist: [Playlist] = []

	init() {
		publicPlaylistItem.observeValue { [weak self] snapshot in
			var playlists: [Playlist] = []

			guard let result = snapshot.value as? [[String: String]] else { return }

			for element in result {
				let playlist = Playlist(
					id: element[Playlist.Key.id.rawValue] ?? "",
					name: element[Playlist.Key.name.rawValue] ?? "",
					createdBy: element[Playlist.Key.createdBy.rawValue] ?? "",
					type: .public
				)

				playlists.append(playlist)
			}

			self?.publicPlaylist = playlists
		}

		publicPlaylistItem.observeValue { [weak self] snapshot in
			var playlists: [Playlist] = []

			guard let result = snapshot.value as? [[String: String]] else { return }

			for element in result {
				let playlist = Playlist(
					id: element[Playlist.Key.id.rawValue] ?? "",
					name: element[Playlist.Key.name.rawValue] ?? "",
					createdBy: element[Playlist.Key.createdBy.rawValue] ?? "",
					type: .private
				)

				playlists.append(playlist)
			}

			self?.privatePlaylist = playlists
		}
	}
}
