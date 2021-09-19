//
//  PlaylistModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for PlaylistModel
protocol PlaylistModelProtocol {

	/// Private playlist item in database.
	var privatePlaylistItem: DatabaseItem { get }

	/// Public playlist item in database.
	var publicPlaylistItem: DatabaseItem { get }

	/// Handler that updates view in PlaylistView.
	var updateView: (() -> Void)? { get set }

	/// Storage with private playlists(ones that corresponds to a certain user).
	var privatePlaylist: [Playlist] { get }

	/// Storage with public playlists(ones that are available to everone).
	var publicPlaylist: [Playlist] { get }

	/// Current user's id.
	var currentUserId: String { get }
}
