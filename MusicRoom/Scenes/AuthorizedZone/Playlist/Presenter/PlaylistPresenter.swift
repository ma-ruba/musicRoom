//
//  PlaylistPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class PlaylistPresenter: PlaylistPresenterProtocol {
	unowned private var view: PlaylistViewProtocol
	private var model: PlaylistModelProtocol

	init(view: PlaylistViewProtocol) {
		self.view = view

		model = PlaylistModel()
		model.updateView = {
			view.reloadTableView()
		}
		model.showError = {
			view.showBasicAlert(message: LocalizedStrings.Playlist.unableToDelete.localized)
		}
	}

	// MARK: - PlaylistPresenterProtocol

	var numberOfSections: Int {
		PlaylistType.allCases.count
	}

	func typeName(for section: Int) -> String? {
		guard let playlistType = PlaylistType.init(rawValue: section) else { return nil }

		return playlistType.name
	}

	func numberOfRows(in section: Int) -> Int {
		guard let playlistType = PlaylistType.init(rawValue: section) else { return 0 }

		switch playlistType {
		case .private:
			return model.privatePlaylist.count

		case .public:
			return model.publicPlaylist.count
		}
	}

	func playlist(for indexPath: IndexPath) -> PlaylistItem? {
		guard let playlistType = PlaylistType.init(rawValue: indexPath.section) else { return nil }

		switch playlistType {
		case .private:
			return model.privatePlaylist[safe: indexPath.row]

		case .public:
			return model.publicPlaylist[safe: indexPath.row]
		}
	}

	func addPlaylist() {
		let addPlaylistsViewController = AddPlaylistTableViewController()
		view.navigationController?.pushViewController(addPlaylistsViewController, animated: true)
	}

	func openPlaylist(at indexPath: IndexPath) {
		guard let playlistType = PlaylistType.init(rawValue: indexPath.section) else { return }
		var selectedPlaylist: PlaylistItem?

		switch playlistType {
		case .private:
			selectedPlaylist = model.privatePlaylist[safe: indexPath.row]
			
		case .public:
			selectedPlaylist = model.publicPlaylist[safe: indexPath.row]
		}

		guard let playlist = selectedPlaylist else { return }

		let viewController = ShowPlaylistViewController(with: playlist)
		view.navigationController?.pushViewController(viewController, animated: true)
	}

	func deletePlaylist(at indexPath: IndexPath) {
		guard let playlistType = PlaylistType.init(rawValue: indexPath.section) else { return }

		switch playlistType {
		case .private:
			guard model.privatePlaylist[safe: indexPath.row] != nil else { return }

		case .public:
			guard model.publicPlaylist[safe: indexPath.row] != nil else { return }
		}

		model.deletePlaylist(at: indexPath)
	}
}
