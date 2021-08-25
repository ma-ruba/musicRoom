//
//  AddPlaylistModel.swift
//  MusicRoom
//
//  Created by Mariia on 23.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Type of items(cells) on AddPlaylistView. RawValue corresponds to the row of item in tableView.
enum AddPlaylistItemType: Int {

	/// cell with new playist name
	case name = 0

	/// cell with the playlist type(public/private)
	case type

	/// cell with create button
	case button
}

struct AddPlaylistModel {
	/// added playlist
	var playlist: PlaylistItem
}
