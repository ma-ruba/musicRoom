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
	private var model: ShowPlaylistModelProtocol?

	var numberOfSections: Int {
		1
	}

	var playlistName: String {
		model?.playlist.name ?? ""
	}

	var isAddFriendsButtonEnabled: Bool {
		model?.playlist.type == .private
	}

	var tracks: [PlaylistTrack] {
		model?.playlist.sortedTracks ?? []
	}

	// MARK: Initializzation

	init(view: ShowPlaylistViewProtocol) {
		self.view = view
	}

	// MARK: - ShowPlaylistPresenterProtocol

	func configureModel(with inputModel: PlaylistItem) {
		model = ShowPlaylistModel(playlist: inputModel)
	}

	func addSong() {
		guard let playlist = model?.playlist else { return }
		let searchSongViewController = SearchSongViewController(with: playlist)
		view.navigationController?.pushViewController(searchSongViewController, animated: true)
	}

	func deleteTrack(at index: Int) {
		model?.deleteTrack(at: index)
	}

	func reorderTrack(from startIndex: Int, to finalIndex: Int) {
		model?.reorderTrack(from: startIndex, to: finalIndex)
	}
}
