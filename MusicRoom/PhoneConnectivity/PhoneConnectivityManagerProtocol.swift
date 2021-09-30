//
//  PhoneConnectivityManagerProtocol.swift
//  MusicRoom
//
//  Created by 18588255 on 28.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol PhoneConnectivityManagerProtocol: AnyObject {
	func configure()
	func sendMessage(
		message: [String: Any],
		replyHandler: (([String: Any]) -> Void)?,
		errorHandler: ((Error) -> Void)?
	)
}
