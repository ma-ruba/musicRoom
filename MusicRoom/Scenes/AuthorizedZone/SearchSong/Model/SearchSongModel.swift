//
//  SearchSongModel.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class SearchSongModel: SearchSongModelProtocol {
	var currentSearch: String = ""

	var numberOfTracks: Int {
		Int(cachedTracks.object(forKey: NSString(string: currentSearch))?.list.count() ?? 0)
	}

	var cachedTracks: NSCache<NSString, DeezerTarckList> = NSCache()
	var tracksItem: DatabaseItem

	private var playlist: Playlist

	// MARK: Initialization

	init(playlist: Playlist) {
		self.playlist = playlist
		
		switch playlist.type {
		case .private:
			tracksItem = DatabaseItem(
				path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + playlist.createdBy + DatabasePath.slash.rawValue +
					DatabasePath.playlists.rawValue + playlist.id + DatabasePath.slash.rawValue + DatabasePath.tracks.rawValue
			)

		case .public:
			tracksItem = DatabaseItem(
				path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue + playlist.id
					+ DatabasePath.slash.rawValue + DatabasePath.tracks.rawValue
			)
		}

		tracksItem.observeValue { [weak self] snapshot in
			self?.playlist = Playlist(snapshot: snapshot)
		}
	}
}
