//
//  SearchSongModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for SearchSongModel.
protocol SearchSongModelProtocol {

	/// Current search query.
	var currentSearch: String { get set }

	/// Number of tracks found.
	var numberOfTracks: Int { get }

	/// Cached tracks.
	var cachedTracks: [String: DeezerTarckList] { get }

	/// Method adds a new track to the track list.
	func addNewTrack(at index: Int)

	/// Method returns track model at certain index.
	func getTrack(at index: Int) -> Track?
}
