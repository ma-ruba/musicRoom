//
//  MusicController.swift
//  MusicRoom
//
//  Created by 18588255 on 14.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

class MusicController: NSObject, DZRPlayable, DZRPlayableIterator {
	private var playablePath: String
	private var playableRef: DatabaseReference?
	private var playableHandle: UInt?

	var tracks: [Track]?

	var snapshotHandler: SnapshotHandler?
	private var firstTimePlaying = true

	// MARK: lifecycle

	init(path: String, takeOverFrom: MusicController?) {
		self.playablePath = path

		super.init()

		playableRef = Database.database().reference(withPath: path)

		var firstSnapshot = true
		playableHandle = playableRef?.observe(.value, with: { snapshot in
			self.snapshotHandler?.snapshotChanged(snapshot: snapshot)

			if firstSnapshot {
				firstSnapshot = false

				if self == DeezerSession.sharedInstance.controller {
					self.play()
				}

				takeOverFrom?.destroy()
			}
		})
	}

	func destroy() {
		if let ref = playableRef, let handle = playableHandle {
			ref.removeObserver(withHandle: handle)
		}
	}

	func play() {
		if self.firstTimePlaying {
			self.firstTimePlaying = false

			DeezerSession.sharedInstance.deezerPlayer?.play(self)
		} else {
			DeezerSession.sharedInstance.deezerPlayer?.play()
		}

		DeezerSession.sharedInstance.playerDelegate?.changePlayPauseButtonState(to: true)
	}

	func pause() {
		DeezerSession.sharedInstance.deezerPlayer?.pause()
		DeezerSession.sharedInstance.playerDelegate?.changePlayPauseButtonState(to: false)
	}

	func getTrackFor(dzrId: String) -> Track? {
		if let tracks = self.tracks {
			for track in tracks {
				if track.deezerId == dzrId {
					return track
				}
			}
		}

		return nil
	}

	func identifier() -> String {
		return "I am a string"
	}

	func iterator() -> DZRPlayableIterator {
		return self
	}

	func current(with requestManager: DZRRequestManager, callback: DZRTrackFetchingCallback?) {
	}

	func next(with requestManager: DZRRequestManager, callback: DZRTrackFetchingCallback?) {
	}
}


