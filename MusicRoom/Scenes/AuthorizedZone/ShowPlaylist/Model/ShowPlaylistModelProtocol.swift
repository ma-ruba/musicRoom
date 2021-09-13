//
//  ShowPlaylistModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for ShowPlaylistModel
protocol ShowPlaylistModelProtocol: AnyObject {

	/// Dispayed playlist.
	var playlist: Playlist { get }

	/// Entity of playlist  for database.
	var playlistItem: DatabaseItem { get }
}
