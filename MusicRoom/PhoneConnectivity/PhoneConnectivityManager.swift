//
//  PhoneConnectivityManager.swift
//  MusicRoom
//
//  Created by 18588255 on 28.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import WatchConnectivity

final class PhoneConnectivityManager : NSObject, WCSessionDelegate, PhoneConnectivityManagerProtocol {
	static let shared = PhoneConnectivityManager()

	private var session: WCSession?
	private var validReachableSession: WCSession? {
		guard let session = session,
			session.isPaired && session.isWatchAppInstalled,
			session.isReachable
		else { return nil }

		return session
	}

	// MARK: Initialization

	init(session: WCSession = WCSession.default) {
		self.session = WCSession.isSupported() ? session : nil

		super.init()

		session.delegate = self
		session.activate()
	}

	// MARK: - WCSessionDelegate

	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

	func sessionDidBecomeInactive(_ session: WCSession) {}

	func sessionDidDeactivate(_ session: WCSession) {
		self.session?.activate()
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		guard let state = message[ConnectivityKeys.playingState.rawValue] as? PlayingState else { return }

		switch state {
		case .isPlaying:
			DeezerManager.sharedInstance.play()

		case .isSuspended:
			DeezerManager.sharedInstance.pause()

		case .disabled:
			break
		}
	}

	// MARK: - PhoneConnectivityManagerProtocol

	func configure() {
		session?.delegate = self
		session?.activate()
	}

	func sendMessage(
		message: [String: Any],
		replyHandler: (([String: Any]) -> Void)? = nil,
		errorHandler: ((Error) -> Void)? = nil
	) {
		validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
	}
}
