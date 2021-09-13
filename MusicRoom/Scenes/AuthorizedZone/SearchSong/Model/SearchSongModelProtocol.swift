//
//  SearchSongModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Interface for SearchSongModel.
protocol SearchSongModelProtocol {
	
	/// Entity of tracks in database.
	var tracksItem: DatabaseItem { get }

	/// Current search query.
	var currentSearch: String { get set }

	/// Number of tracks found.
	var numberOfTracks: Int { get }

	/// Cached tracks.
	var cachedTracks: NSCache<NSString, DeezerTarckList> { get }
}
