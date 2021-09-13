//
//  AddPlaylistPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 23.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for AddPlaylistPresenter
protocol AddPlaylistPresenterProtocol {

	/// Property that describes number of sections in the tableView in AddPlaylistView.
	var numberOfSections: Int { get }

	/// Property  shows if the name of Playlist is set.
	var isNameFieldEmpty: Bool { get }

	/// Method  describes number of rows in certain section in the tableView in AddPlaylistView.
	func numberOfRows(in section: Int) -> Int

	/// Method return the type of item(cells) for indexPath  on AddPlaylistView.
	func item(for indexPath: IndexPath) -> AddPlaylistType?

	/// Method updtaes name of playlist  in model.
	func updatePlaylistName(with name: String)

	/// Method updtaes type of playlist(public/private) in model.
	func updatePlaylistType()

	/// Method creates a new playlist.
	func createPlaylist()
}
