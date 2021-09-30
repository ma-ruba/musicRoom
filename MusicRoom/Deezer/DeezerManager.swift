//
//  DeezerSession.swift
//  MusicRoom
//
//  Created by Mariia on 08.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

/// Manager for working with Deezer SDK.
final class DeezerManager : NSObject, DeezerSessionDelegate {

	static let sharedInstance : DeezerManager = {
		let instance = DeezerManager()
		instance.startDeezer()
		return instance
	}()

	var trackToPlay: Track?

	var deezerConnect: DeezerConnect?
	var deezerPlayer: DZRPlayer?

	var playingState: PlayingState {
		if deezerPlayer?.isPlaying() == true {
			return .isPlaying

		} else if deezerPlayer?.isReady() == true {
			return .isSuspended

		} else {
			trackToPlay = nil
			return .disabled
		}
	}

	func setDelegate(_ delegate: DZRPlayerDelegate) {
		deezerPlayer?.delegate = delegate
	}

	func play(track: TrackToPlay) {
		trackToPlay = track.track
		deezerPlayer?.play(track.deezerTrack)
		let message = createMessageForWatch(with: .isPlaying)
		PhoneConnectivityManager.shared.sendMessage(message: message)
	}

	func play() {
		guard deezerPlayer?.isReady() == true else { return }
		deezerPlayer?.play()
		let message = createMessageForWatch(with: .isPlaying)
		PhoneConnectivityManager.shared.sendMessage(message: message)
	}

	func pause() {
		guard deezerPlayer?.isPlaying() == true else { return }

		deezerPlayer?.pause()
		let message = createMessageForWatch(with: .isSuspended)
		PhoneConnectivityManager.shared.sendMessage(message: message)
	}

	func stop() {
		guard deezerPlayer?.isPlaying() == true else { return }

		deezerPlayer?.stop()
		let message = createMessageForWatch(with: .disabled)
		PhoneConnectivityManager.shared.sendMessage(message: message)
	}

	// MARK: - Private

	private func startDeezer() {
		deezerConnect = DeezerConnect(appId: GlobalConstants.deezerAppId, andDelegate: self)
		DZRRequestManager.default().dzrConnect = deezerConnect
		deezerPlayer = DZRPlayer(connection: deezerConnect)
		deezerPlayer?.shouldUpdateNowPlayingInfo = true
	}

	private func createMessageForWatch(with state: PlayingState) -> [String: Any] {
		guard let deezerPlayer = deezerPlayer,
			let trackToPlay = trackToPlay
		else { return [:] }

		return [
			ConnectivityKeys.trackName.rawValue: "\(trackToPlay.name) by \(trackToPlay.creator)",
			ConnectivityKeys.playingState.rawValue: playingState.rawValue,
			ConnectivityKeys.playbackProgress.rawValue: String(deezerPlayer.progress)
		]
	}
}
