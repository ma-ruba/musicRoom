//
//  ShowPlaylistModel.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class ShowPlaylistModel: ShowPlaylistModelProtocol {
	var playlist: Playlist
	private var playlistItem: DatabaseItem

	// MARK: Initialization

	init(playlist: PlaylistItem) {
		self.playlist = Playlist(name: playlist.name, userId: playlist.uid, type: playlist.type)

		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		playlistItem = DatabaseItem(
			path: DatabasePath.user.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue + self.playlist.createdBy
		)

		playlistItem.handle = playlistItem.reference.observe(.value) { [weak self] snapshot in
			self?.playlist = Playlist(snapshot: snapshot)
		}
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - ShowPlaylistModelProtocol

	func deleteTrack(at index: Int) {
		guard let trackId = playlist.sortedTracks[safe: index]?.trackKey else { return }

		let path = DatabasePath.tracks.rawValue + DatabasePath.slash.rawValue + trackId
		playlistItem.reference.child(path).removeValue() { [weak self] error, _ in
				Log.event(
					"deleted_track",
					parameters: [
						"playlist_id": self?.playlist.createdBy ?? "undefined",
						"track_id": trackId,
					]
				)
		}
	}

	func reorderTrack(from startIndex: Int, to finalIndex: Int) {
		let trackId = playlist.sortedTracks[startIndex].trackKey

		let path = DatabasePath.tracks.rawValue + trackId + DatabasePath.slash.rawValue + DatabasePath.orderNumber.rawValue
		playlistItem.reference.child(path).setValue(finalIndex) { error, _ in
			Log.event("set_track_order_number")
		}
	}

	// MARK: - Private

	private func tearDownDatabase() {
		if let handle = playlistItem.handle {
			playlistItem.reference.removeObserver(withHandle: handle)
		}
	}
}
