//
//  SearchSongPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class SearchSongPresenter: SearchSongPresenterProtocol {
	private unowned var view: SearchSongViewProtocol
	private var model: SearchSongModel

	var numberOfSections: Int {
		1
	}

	var numberOfRows: Int {
		model.numberOfTracks
	}

	// MARK: Initializzation

	init(view: SearchSongViewProtocol, inputModel: Playlist) {
		self.view = view
		
		model = SearchSongModel(playlist: inputModel)
	}

	// MARK: - SearchSongPresenterProtocol

	func addNewTrack(at index: Int) {
		guard let track = model.cachedTracks.object(forKey: NSString(string: model.currentSearch))?.tracks[safe: index] else { return }
		let newSongRef = model.tracksItem.reference.childByAutoId()

		newSongRef.setValue(track.object) { error, _ in
			guard error == nil else {
				return print(error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription)
			}
		}
		
		view.navigationController?.popViewController(animated: true)
	}

	func filterContentForSearchText(searchText: String) {
		guard !searchText.isEmpty else { return }
		model.currentSearch = searchText
		guard model.cachedTracks.object(forKey: NSString(string: model.currentSearch)) == nil else { return view.reloadTableView() }

		DZRObject.search(
			for: DZRSearchType.track,
			withQuery: searchText,
			requestManager: DZRRequestManager.default()
		) { [weak self] (results: DZRObjectList?, error: Error?) -> Void in
			guard let self = self, let results = results, error == nil else { return }

			self.model.cachedTracks.setObject(DeezerTarckList(list: results), forKey: NSString(string: searchText))
			self.view.reloadTableView()
		}
	}

	func getCellModel(at index: Int) -> LabelsTableViewCellModel? {
		if let track = model.cachedTracks.object(forKey: NSString(string: model.currentSearch))?.tracks[safe: index] {
			return createModel(for: track)
		}

		// TODO: This is not elegant approach. Redo!
		DispatchQueue.global(qos: .userInteractive).async {
			let deezerManager = DZRRequestManager.default()
			self.model.cachedTracks
				.object(forKey: NSString(string: self.model.currentSearch))?.list.object(at: UInt(index), with: deezerManager)
			{ result, error in
				guard error == nil,
					let deezerTrack = result as? DZRTrack,
					let deezerTrackId = deezerTrack.identifier() else { return }

				deezerTrack.playableInfos(with: deezerManager) { [weak self] songInfo, error in
					guard let self = self,
						let name = songInfo?[DeezerKey.trackName.rawValue] as? String,
						let creator = songInfo?[DeezerKey.trackCreator.rawValue] as? String,
						let duration = songInfo?[DeezerKey.trackDuration.rawValue] as? Int
					else { return }

					let track = Track(
						id: deezerTrack.identifier(),
						name: name,
						creator: creator,
						duration: duration,
						deezerId: deezerTrackId
					)
					self.model.cachedTracks.object(forKey: NSString(string: self.model.currentSearch))?.tracks.append(track)
					self.model.cachedTracks.object(forKey: NSString(string: self.model.currentSearch))?.deezerTracks?.append(deezerTrack)
					self.view.reloadCellForRow(at: index)
				}
			}
		}

		guard  let track = model.cachedTracks.object(forKey: NSString(string: model.currentSearch))?.tracks[safe: index] else { return nil }

		return createModel(for: track)
	}

	// MARK: - Private

	private func createModel(for track: Track) -> LabelsTableViewCellModel {
		return LabelsTableViewCellModel(
			mainLabelText: track.name,
			firstAdditionalInfoLabelText: track.creator,
			secondAdditionalInfoLabelText: String(format: "%01d:%02d", track.duration / 60, track.duration % 60)
		)
	}
}
