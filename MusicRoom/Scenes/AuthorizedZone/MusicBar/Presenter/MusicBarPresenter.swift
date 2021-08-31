//
//  MusicBarPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class MusicBarPresenter: MusicBarPresenterProtocol {
	unowned private var view: MusicBarViewProtocol
	private var model: MusicBarModel?

	var currentState: PlayingState {
		model?.playingState ?? .disabled
	}

	init(view: MusicBarViewProtocol) {
		self.view = view

		model = MusicBarModel()
	}

	// MARK: - MusicBarPresenterProtocol

	func buttonPressed() {
		switch model?.playingState {
		case .play:
			DeezerSession.sharedInstance.controller?.pause()

		default:
			DeezerSession.sharedInstance.controller?.play()
		}
	}

	func setupPlayerDelegate() {
		DeezerSession.sharedInstance.setUp(playerDelegate: view)
	}

	// TODO: Do smth with playing
	func setupPlayButtonState() {
		if DeezerSession.sharedInstance.deezerPlayer?.isPlaying() == true {
			view.changePlayPauseButtonState(to: .play)
		} else if DeezerSession.sharedInstance.deezerPlayer?.isReady() == true {
			view.changePlayPauseButtonState(to: .pause)
		} else {
			view.changePlayPauseButtonState(to: .disabled)
		}
	}

	func setNewState(_ state: PlayingState) {
		model?.playingState = state
	}
}
