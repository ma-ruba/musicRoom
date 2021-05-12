//
//  PlayerDelegate.swift
//  MusicRoom
//
//  Created by 18588255 on 08.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol PlayerDelegate {
	func didStartPlaying(track: Track?)
	func changePlayPauseButtonState(to newState: Bool?)
}
