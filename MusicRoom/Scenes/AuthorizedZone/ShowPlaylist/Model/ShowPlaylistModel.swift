//
//  ShowPlaylistModel.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class ShowPlaylistModel: ShowPlaylistModelProtocol {

	var playlist: Playlist {
		didSet {
			updateView?()
		}
	}

	var playlistItem: DatabaseItem

	private var updateView: (() -> Void)?

	// MARK: Initialization

	init(playlist: Playlist, completion: (() -> Void)?) {
		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		self.playlist = playlist
		self.updateView = completion

		switch playlist.type {
		case .private:
			playlistItem = DatabaseItem(
				path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue + playlist.id
			)

		case .public:
			playlistItem = DatabaseItem(
				path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue + playlist.id
			)
		}

		playlistItem.handle = playlistItem.reference.observe(.value) { [weak self] snapshot in
			self?.playlist = Playlist(snapshot: snapshot)
		}
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - Private

	private func tearDownDatabase() {
		if let handle = playlistItem.handle {
			playlistItem.reference.removeObserver(withHandle: handle)
		}
	}
}
