//
//  ShowPlaylistModel.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class ShowPlaylistModel: ShowPlaylistModelProtocol {
	var tracks: [PlaylistTrack] = []

	var playlist: Playlist

	var tracksItem: DatabaseItem

	private var updateView: (() -> Void)?

	// MARK: Initialization

	init(playlist: Playlist, completion: (() -> Void)?) {
		self.updateView = completion
		self.playlist = playlist

		switch playlist.type {
		case .private:
			tracksItem = DatabaseItem(
				path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + playlist.createdBy + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue + playlist.id + DatabasePath.slash.rawValue + DatabasePath.tracks.rawValue
			)

		case .public:
			tracksItem = DatabaseItem(
				path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue + playlist.id + DatabasePath.slash.rawValue + DatabasePath.tracks.rawValue
			)
		}

		tracksItem.observeValue { [weak self] snapshot in
			self?.tracks.removeAll()
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let track = PlaylistTrack(snapshot: snap)

				self?.tracks.append(track)
			}
			self?.updateView?()
		}
	}
}
