//
//  DeezerSession.swift
//  MusicRoom
//
//  Created by 18588255 on 08.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import Firebase
import FirebaseInstallations

final class DeezerSession : NSObject, DeezerSessionDelegate, DZRPlayerDelegate {

	static let sharedInstance = DeezerSession()

	var deezerConnect: DeezerConnect?
	var deezerPlayer: DZRPlayer?
	var currentUser: DZRUser?
	var playerDelegate: PlayerDelegate?

	var controller: MusicController?

	public var deviceId: String?

	func setUp(playerDelegate: PlayerDelegate) {
		self.playerDelegate = playerDelegate

		deezerConnect = DeezerConnect(appId: "453502", andDelegate: DeezerSession.sharedInstance)
		DZRRequestManager.default().dzrConnect = deezerConnect
		deezerPlayer = DZRPlayer(connection: deezerConnect)
		deezerPlayer?.delegate = self

		Installations.installations().installationID { (instanceId, error) in
			self.deviceId = instanceId
		}
	}

	// MARK: login, logout

	func deezerDidLogin() {

		DZRUser.object(withIdentifier: "me", requestManager:DZRRequestManager.default(), callback: {(_ objs: Any?, _ error: Error?) -> Void in
			if let user = objs as? DZRUser {
				self.currentUser = user
			}
		})

		if let viewController = UIApplication.topViewController() as? SettingsViewController  {
			viewController.tableView.reloadData()
		}
	}

	func deezerDidLogout() {
	}

	func deezerDidNotLogin(cancelled: Bool) {
	}

	// MARK: setting the music

	public func setMusic(toPlaylist path: String, startingAt startIndex: Int?) {
		controller = PlaylistController(playlist: path, startIndex: startIndex, takeOverFrom: self.controller)
	}

	public func clearMusic() {
		controller?.destroy()
		controller = nil

		deezerPlayer?.pause()
		playerDelegate?.changePlayPauseButtonState(to: .disabled)
		playerDelegate?.didStartPlaying(track: nil)
	}

	// MARK: DZRPlayerDelegate

	func player(_ player: DZRPlayer, didStartPlaying: DZRTrack) {
		let track = controller?.getTrackFor(dzrId: didStartPlaying.identifier())

		playerDelegate?.didStartPlaying(track: track)
	}
}

