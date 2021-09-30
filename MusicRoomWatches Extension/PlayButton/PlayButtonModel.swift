//
//  PlayButtonModel.swift
//  MusicRoomWatch Extension
//
//  Created by 18588255 on 21.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import SwiftUI

/// Model of play/pause button
struct PlayButtonModel {

	/// Playing state.
	var state: PlayingState = .disabled

	/// Progress of the track duration. Range from 0 to 1.
	var progress: Double

	/// Image name.
	var imageName: String {
		switch state {
		case .disabled:
			return ""

		case .isPlaying:
			return "play"

		case .isSuspended:
			return "pause"
		}
	}

	/// Action when tapping the button.
	var action: () -> Void
}
