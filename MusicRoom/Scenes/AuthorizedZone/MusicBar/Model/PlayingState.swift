//
//  PlayingState.swift
//  MusicRoom
//
//  Created by 18588255 on 21.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// State of the playing button on MusicBar.
enum PlayingState: String {

	/// Disabled. No button on the bar.
	case disabled

	/// The track is playing currently. Stop button is displayed.
	case isPlaying

	/// The track previously playing was suspended. Play button is displayed.
	case isSuspended

	mutating func toggle() {
		switch self {
		case .isPlaying:
			self = .disabled

		case .isSuspended:
			self = .isPlaying

		case .disabled:
			break
		}
	}
}
