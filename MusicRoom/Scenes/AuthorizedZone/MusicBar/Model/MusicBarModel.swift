//
//  MusicBarModel.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// State of the playing button on MusicBar.
enum PlayingState {

	/// Disabled. No button on the bar.
	case disabled

	/// The track is playing currently. Stop button is displayed.
	case isPlaying

	/// The track previously playing was suspended. Play button is displayed.
	case isSuspended
}

final class MusicBarModel: MusicBarModelProtocol {
	var playingState: PlayingState {
		if DeezerManager.sharedInstance.deezerPlayer?.isPlaying() == true {
			return .isPlaying

		} else if DeezerManager.sharedInstance.deezerPlayer?.isReady() == true {
			return .isSuspended

		} else {
			DeezerManager.sharedInstance.trackToPlay = nil
			return .disabled
		}
	}
	var playingInfo: String {
		switch playingState {
		case .isPlaying, .isSuspended:
			guard let trackToPlay = DeezerManager.sharedInstance.trackToPlay else { return  LocalizedStrings.MusicBar.notActive.localized }

			return LocalizedStrings.MusicBar.playingInfo.localized(withArgs: trackToPlay.name, trackToPlay.creator)

		case .disabled:
			return LocalizedStrings.MusicBar.notActive.localized
		}
	}
}
