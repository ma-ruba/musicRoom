//
//  ShowPlaylistPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 26.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class ShowPlaylistPresenter: ShowPlaylistPresenterProtocol {
	private unowned var view: ShowPlaylistViewProtocol
	private var model: ShowPlaylistModelProtocol

	var numberOfSections: Int {
		1
	}

	var playlistName: String {
		model.playlist.name
	}

	var tracks: [PlaylistTrack] {
		model.playlist.sortedTracks
	}

	// MARK: Initializzation

	init(view: ShowPlaylistViewProtocol, inputModel: Playlist) {
		self.view = view

		model = ShowPlaylistModel(playlist: inputModel) {
			view.reloadTableView()
		}
	}

	// MARK: - ShowPlaylistPresenterProtocol

	func addSong() {
		let searchSongViewController = SearchSongViewController(with: model.playlist)
		view.navigationController?.pushViewController(searchSongViewController, animated: true)
	}

	func deleteTrack(at index: Int) {
		guard let trackId = model.playlist.sortedTracks[safe: index]?.trackKey else { return }

		let path = DatabasePath.tracks.rawValue + DatabasePath.slash.rawValue + trackId
		model.playlistItem.reference.child(path).removeValue() { [weak self] error, _ in
			guard error == nil else {
				return print(error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription)
			}

			Analytics.logEvent(
				"deleted_track",
				parameters: [
					"playlist_id": self?.model.playlist.id ?? "undefined",
					"track_id": trackId,
				]
			)
		}
	}

	func reorderTrack(from startIndex: Int, to finalIndex: Int) {
		let trackId = model.playlist.sortedTracks[startIndex].trackKey

		let path = DatabasePath.tracks.rawValue + trackId + DatabasePath.slash.rawValue + DatabasePath.orderNumber.rawValue
		model.playlistItem.reference.child(path).setValue(finalIndex) { error, _ in
			guard error == nil else {
				return print(error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription)
			}
		}
	}

	func playTrack(at index: Int) {
		guard let deezerTrackId = model.playlist.sortedTracks[safe: index]?.deezerId,
			let track = model.playlist.sortedTracks[safe: index] else { return }

		DispatchQueue.global(qos: .userInitiated).async {
			DZRTrack.object(withIdentifier: deezerTrackId, requestManager: DZRRequestManager.default()) { [weak self] deezerTrack, error in
				guard error == nil else {
					self?.view.showBasicAlert(
						message: error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription
					)
					return
				}

				guard let deezerTrack = deezerTrack as? DZRTrack else { return }
				DeezerManager.sharedInstance.play(track: TrackToPlay(track: track, deezerTrack: deezerTrack))
			}
		}
	}
}
