//
//  MusicBarModel.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class MusicBarModel: MusicBarModelProtocol {
	var playingState: PlayingState {
		DeezerManager.sharedInstance.playingState
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
