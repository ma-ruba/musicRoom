//
//  MusicBarPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class MusicBarPresenter: NSObject, MusicBarPresenterProtocol, DZRPlayerDelegate {
	unowned private var view: MusicBarViewProtocol
	private var model: MusicBarModel

	var currentState: PlayingState {
		model.playingState
	}

	var playingInfo: String {
		model.playingInfo
	}

	init(view: MusicBarViewProtocol) {
		self.view = view

		model = MusicBarModel()
	}

	// MARK: - DZRPlayerDelegate

	func playerDidPause(_ player: DZRPlayer!) {
		view.updateAppearance()
	}

	func player(_ player: DZRPlayer!, didStartPlaying track: DZRTrack!) {
		view.updateAppearance()
	}

	// MARK: - MusicBarPresenterProtocol

	func buttonPressed() {
		switch model.playingState {
		case .isPlaying:
			DeezerManager.sharedInstance.pause()

		case .isSuspended:
			DeezerManager.sharedInstance.play()

		default:
			break
		}
	}

	func setupPlayerDelegate() {
		DeezerManager.sharedInstance.setDelegate(self)
	}
}
