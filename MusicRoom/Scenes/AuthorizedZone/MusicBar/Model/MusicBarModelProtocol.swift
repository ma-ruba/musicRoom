//
//  MusicBarModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 08.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for MusicBarModel
protocol MusicBarModelProtocol {

	/// Info about playing track or info about it's absence.
	var playingInfo: String { get }

	/// Playing state.
	var playingState: PlayingState { get }
}
