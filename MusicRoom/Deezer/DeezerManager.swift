//
//  DeezerSession.swift
//  MusicRoom
//
//  Created by Mariia on 08.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class DeezerManager : NSObject, DeezerSessionDelegate {

	static let sharedInstance : DeezerManager = {
		let instance = DeezerManager()
		instance.startDeezer()
		return instance
	}()

	var trackToPlay: Track?

	var deezerConnect: DeezerConnect?
	var deezerPlayer: DZRPlayer?

	private func startDeezer() {
		deezerConnect = DeezerConnect(appId: GlobalConstants.deezerAppId, andDelegate: self)
		DZRRequestManager.default().dzrConnect = deezerConnect
		deezerPlayer = DZRPlayer(connection: deezerConnect)
		deezerPlayer?.shouldUpdateNowPlayingInfo = true
	}

	func setDelegate(_ delegate: DZRPlayerDelegate) {
		deezerPlayer?.delegate = delegate
	}

	func play(track: TrackToPlay) {
		trackToPlay = track.track
		deezerPlayer?.play(track.deezerTrack)
	}

	func play() {
		guard deezerPlayer?.isReady() == true else { return }
		deezerPlayer?.play()
	}

	func pause() {
		guard deezerPlayer?.isPlaying() == true else { return }

		deezerPlayer?.pause()
	}

	func stop() {
		guard deezerPlayer?.isPlaying() == true else { return }

		deezerPlayer?.stop()
	}
}
