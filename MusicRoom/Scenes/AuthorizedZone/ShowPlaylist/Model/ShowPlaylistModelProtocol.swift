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

	/// Method deletes track from the list of tracks.
	func deleteTrack(at index: Int)

	/// Method changes order of the track.
	func reorderTrack(from startIndex: Int, to finalIndex: Int)
}
