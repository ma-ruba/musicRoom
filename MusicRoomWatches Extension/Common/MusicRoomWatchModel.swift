//
//  MusicRoomWatchModel.swift
//  MusicRoomWatch Extension
//
//  Created by 18588255 on 29.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Model of the Watch App.
struct MusicRoomWatchModel {

	/// State of the app.
	var appState: MusicRoomWatchState

	/// Model of the playing track.
	var trackViewModel: TrackViewModel

	// MARK: Initialization

	init(
		trackViewModel: TrackViewModel,
		appState: MusicRoomWatchState = .disabled
	) {
		self.appState = appState
		self.trackViewModel = trackViewModel
	}
}
