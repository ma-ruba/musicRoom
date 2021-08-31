//
//  SearchSongModel.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

struct DeezerTarckList {
	var list: DZRObjectList
	var tracks: [Track] = []
}

final class SearchSongModel: SearchSongModelProtocol {
	var currentSearch: String = ""

	var numberOfTracks: Int {
		Int(cachedTracks[currentSearch]?.list.count() ?? 0)
	}

	var cachedTracks: [String: DeezerTarckList] = [:]

	private var playlist: Playlist
	private var tracksItem: DatabaseItem

	// MARK: Initialization

	init(playlist: Playlist) {
		self.playlist = playlist

		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		tracksItem = DatabaseItem(
			path: DatabasePath.user.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue + playlist.createdBy +
				DatabasePath.slash.rawValue + DatabasePath.tracks.rawValue
		)

		tracksItem.handle = tracksItem.reference.observe(.value) { [weak self] snapshot in
			self?.playlist = Playlist(snapshot: snapshot)
		}
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - SearchSongModelProtocol

	func addNewTrack(at index: Int) {
		guard let track = cachedTracks[currentSearch]?.tracks[safe: index] else { return }
		let newSongRef = tracksItem.reference.childByAutoId()

		newSongRef.setValue(track.object) { error, _ in
			guard error == nil else { return }

			Analytics.logEvent("song_added", parameters: Log.defaultInfo())
		}
	}

	func getTrack(at index: Int) -> Track? {
		let deezerManager = DZRRequestManager.default()

		self.cachedTracks[self.currentSearch]?.list.object(at: UInt(index), with: deezerManager) { result, error in
			guard error == nil, let deezerTrack = result as? DZRTrack else { return }

			deezerTrack.playableInfos(with: deezerManager) { songInfo, error in
				guard let name = songInfo?[DeezerKey.trackName.rawValue] as? String,
					let creator = songInfo?[DeezerKey.trackCreator.rawValue] as? String,
					let duration = songInfo?[DeezerKey.trackDuration.rawValue] as? Int
				else { return }

				let track = Track(id: deezerTrack.identifier(), name: name, creator: creator, duration: duration)
				self.cachedTracks[self.currentSearch]?.tracks.append(track)
			}
		}

		return cachedTracks[currentSearch]?.tracks[safe: index]
	}

	// MARK: - Private

	private func tearDownDatabase() {
		if let handle = tracksItem.handle {
			tracksItem.reference.removeObserver(withHandle: handle)
		}
	}
}
