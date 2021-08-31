//
//  SearchSongPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class SearchSongPresenter: SearchSongPresenterProtocol {
	private unowned var view: SearchSongViewProtocol
	private var model: SearchSongModel?

	var numberOfSections: Int {
		1
	}

	var numberOfRows: Int {
		model?.numberOfTracks ?? 0
	}

	// MARK: Initializzation

	init(view: SearchSongViewProtocol) {
		self.view = view
	}

	// MARK: - SearchSongPresenterProtocol

	func configureModel(with inputModel: Playlist) {
		model = SearchSongModel(playlist: inputModel)
	}

	func addNewTrack(at index: Int) {
		model?.addNewTrack(at: index)
		view.navigationController?.popViewController(animated: true)
	}

	func filterContentForSearchText(searchText: String) {
		guard !searchText.isEmpty else { return }
		model?.currentSearch = searchText
		guard model?.cachedTracks[searchText] == nil else { return view.reloadTableView() }

		DZRObject.search(
			for: DZRSearchType.track,
			withQuery: searchText,
			requestManager: DZRRequestManager.default()
		) { [weak self] (results: DZRObjectList?, error: Error?) -> Void in
			guard let self = self, let results = results, error == nil else { return }

			self.model?.cachedTracks[searchText] = DeezerTarckList(list: results)
			self.view.reloadTableView()
		}
	}

	func getTrack(at index: Int) -> Track? {
		return model?.getTrack(at: index)
	}
}
