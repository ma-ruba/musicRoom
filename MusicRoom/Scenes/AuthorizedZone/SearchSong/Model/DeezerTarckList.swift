//
//  DeezerTarckList.swift
//  MusicRoom
//
//  Created by Mariia on 06.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

// It has to be a class in order to satisfy NSCache requirments.
final class DeezerTarckList {
	
	/// List of songs received from Deezer.
	var list: DZRObjectList
	
	/// List of tracks in representable form.
	var tracks: [Track]

	/// List of tracks from Deezer.
	var deezerTracks: [DZRTrack]?
	
	init(list: DZRObjectList, tracks: [Track] = []) {
		self.list = list
		self.tracks = tracks
	}
}
