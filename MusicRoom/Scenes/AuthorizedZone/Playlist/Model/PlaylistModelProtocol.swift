//
//  PlaylistModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for PlaylistModel
protocol PlaylistModelProtocol {

	/// Handler that updates view in PlaylistView.
	var updateView: (() -> Void)? { get set }

	/// Handler that shows error from PlaylistView.
	var showError: (() -> Void)? { get set }

	/// Storage with private playlists(ones that corresponds to a certain user).
	var privatePlaylist: [PlaylistItem] { get }

	/// Storage with public playlists(ones that are available to everone).
	var publicPlaylist: [PlaylistItem] { get }

	/// Method deletes a certain playlist.
	func deletePlaylist(at indexPath: IndexPath)
}
