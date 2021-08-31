//
//  MusicBarPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for MusicBarPresenter.
protocol MusicBarPresenterProtocol {

	/// Current state of musicBar(disabled/play/pause)
	var currentState: PlayingState { get }

	/// Method stops or starts playing a song.
	func buttonPressed()

	/// Method setups PlayerDelegate.
	func setupPlayerDelegate()

	/// Method configures PlayButton appearance.
	func setupPlayButtonState()

	/// Method changes PlayingState.
	func setNewState(_ state: PlayingState)
}
