//
//  ShowPlaylistModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for ShowPlaylistModel
protocol ShowPlaylistModelProtocol: AnyObject {

	/// Displayed tracks.
	var tracks: [PlaylistTrack] { get }

	/// Current playlist.
	var playlist: Playlist { get }

	/// Entity of tracks list  for database.
	var tracksItem: DatabaseItem { get }
}
