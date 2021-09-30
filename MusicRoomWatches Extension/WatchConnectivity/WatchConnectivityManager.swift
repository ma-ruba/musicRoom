//
//  WatchConnectivityManager.swift
//  MusicRoomWatch Extension
//
//  Created by Mariia on 27.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject, WatchConnectivityManagerProtocol {
	static let shared = WatchConnectivityManager()

	private var session: WCSession?

	@Published var appModel: MusicRoomWatchModel

	private var validReachableSession: WCSession? {
		guard let session = session, session.isReachable else { return nil }

		appModel.appState = .enabled
		return session
	}

	private var messageForIphone: [String: Any] {
		return [
			ConnectivityKeys.playingState.rawValue: appModel.trackViewModel.buttonModel.state
		]
	}

	// MARK: Initialization

	init(session: WCSession = .default) {
		self.session = session

		let buttonModel = PlayButtonModel(progress: 0, action: {})
		let trackModel = TrackViewModel(buttonModel: buttonModel, trackName: "")
		appModel = MusicRoomWatchModel(trackViewModel: trackModel)

		super.init()

		configure()
	}

	// MARK: - WatchConnectivityManagerProtocol

	func sendMessage(
		message: [String: Any],
		replyHandler: (([String: Any]) -> Void)? = nil,
		errorHandler: ((Error) -> Void)? = nil
	) {
		validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
	}

	func sendMessage() {
		validReachableSession?.sendMessage(messageForIphone, replyHandler: nil, errorHandler: nil)
	}

	func configure() {
		session?.delegate = self
		session?.activate()
	}

	// MARK: - WCSessionDelegate

	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if activationState == .activated {
			self.appModel.appState = .enabled
		}
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		createModel(with: message)
	}

	// MARK: - Private

	private func createModel(with message: [String : Any]) {
		guard let trackName = message[ConnectivityKeys.trackName.rawValue] as? String,
			let buttonStateString = message[ConnectivityKeys.playingState.rawValue] as? String,
			let buttonState = PlayingState(rawValue: buttonStateString),
			let progressString = message[ConnectivityKeys.playbackProgress.rawValue] as? String,
			let progress = Double(progressString)
		else { return }

		let buttonModel = PlayButtonModel(state: buttonState, progress: progress, action: sendMessage)
		let trackModel = TrackViewModel(buttonModel: buttonModel, trackName: trackName)

		DispatchQueue.main.async {
			self.appModel.trackViewModel = trackModel
		}
	}
}
