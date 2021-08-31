//
//  PlaylistController.swift
//  MusicRoom
//
//  Created by 18588255 on 14.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

class PlaylistController: MusicController, SnapshotHandler {
	var playlist: Playlist?

	var currentIndex: Int
	var currentDZRTrack: DZRTrack?

	init(playlist path: String, startIndex: Int?, takeOverFrom: MusicController?) {
		self.currentIndex = startIndex ?? 0

		super.init(path: path, takeOverFrom: takeOverFrom)
		self.snapshotHandler = self
	}

	func snapshotChanged(snapshot: DataSnapshot) {
		self.playlist = Playlist(snapshot: snapshot)

		self.tracks = playlist?.sortedTracks

		// TODO: update currentIndex if the song moves or is deleted
	}


	override func current(with requestManager: DZRRequestManager, callback: DZRTrackFetchingCallback?) {
		guard let callback = callback else {
			return
		}

		if let track = self.currentDZRTrack {
			callback(track, nil)
		} else {
			next(with: requestManager, callback: callback)
		}
	}

	override func next(with requestManager: DZRRequestManager, callback: DZRTrackFetchingCallback?) {
		guard let callback = callback else {
			return
		}

		// this is how we know if Deezer has called current or next before -- thanks Deezer!
		if self.currentDZRTrack != nil {
			currentIndex += 1
		}

		if let sortedTracks = self.tracks, currentIndex < sortedTracks.count {
			let track = sortedTracks[currentIndex]

			DZRTrack.object(withIdentifier: track.id, requestManager: DZRRequestManager.default()) {
				( _ trackObject: Any?, _ error: Error?) -> Void in

				if let trackObject = trackObject as? DZRTrack {
					self.currentDZRTrack = trackObject
				} else {
					self.currentDZRTrack = nil
				}

				callback(self.currentDZRTrack, error)
			}
		} else {
			print("Clearing music")

			DeezerSession.sharedInstance.clearMusic()
		}
	}

}
