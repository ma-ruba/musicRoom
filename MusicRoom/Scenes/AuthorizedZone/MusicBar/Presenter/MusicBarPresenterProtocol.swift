//
//  MusicBarPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for MusicBarPresenter.
protocol MusicBarPresenterProtocol: NSObjectProtocol {

	/// Current state of musicBar(disabled/play/pause)
	var currentState: PlayingState { get }

	/// Info about playing track or info about it's absence.
	var playingInfo: String { get }

	/// Method stops or starts playing a song.
	func buttonPressed()

	/// Method setups PlayerDelegate.
	func setupPlayerDelegate()
}
