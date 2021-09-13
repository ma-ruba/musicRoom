//
//  PlaylistPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for PlaylistPresenter
protocol PlaylistPresenterProtocol {

	/// Property that describes number of sections in the tableView in PlaylistView.
	var numberOfSections: Int { get }

	/// Method opens page with the Playlist creation form.
	func addPlaylist()

	/// Method opens page with more profound description of Playlist.
	func openPlaylist(at indexPath: IndexPath)

	/// Method deletes a certain playlist from the list of playlists.
	func deletePlaylist(at indexPath: IndexPath)

	/// Method describes number of rows in certain section in the tableView in PlaylistView.
	func numberOfRows(in section: Int) -> Int

	/// Method returns a model with Playlist for certain indexPath.
	func playlist(for indexPath: IndexPath) -> Playlist?
}
