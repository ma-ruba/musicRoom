//
//  WatchConnectivityManagerProtocol.swift
//  MusicRoomWatch Extension
//
//  Created by 18588255 on 29.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface of the WatchConnectivityManager.
protocol WatchConnectivityManagerProtocol {

	/// Send message to the Iphone.
	func sendMessage(
		message: [String: Any],
		replyHandler: (([String: Any]) -> Void)?,
		errorHandler: ((Error) -> Void)?
	)
}
