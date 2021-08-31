//
//  ShowPlaylistPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for ShowPlaylistPresenter
protocol ShowPlaylistPresenterProtocol {

	/// Name of selected playlist.
	var playlistName: String { get }

	/// Flag that signals if addFriendsButton is enabled.
	var isAddFriendsButtonEnabled: Bool { get }

	/// List of tracks in selected playlist.
	var tracks: [PlaylistTrack] { get }

	/// Property that describes number of sections in the tableView in ShowPlaylistView.
	var numberOfSections: Int { get }

	/// Method configures ShowPlaylistModel.
	func configureModel(with inputModel: PlaylistItem)

	/// Method opens page with the functionality of adding a song.
	func addSong()

	/// Method deletes track from the list of tracks.
	func deleteTrack(at index: Int)

	/// Method changes order of the track.
	func reorderTrack(from startIndex: Int, to finalIndex: Int)
}
