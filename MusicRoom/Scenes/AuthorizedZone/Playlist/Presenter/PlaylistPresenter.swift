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
	var model: PlaylistModelProtocol

	// MARK: Initialization

	init(view: PlaylistViewProtocol) {
		self.view = view

		model = PlaylistModel()
		model.updateView = { [weak self] in
			self?.view.reloadTableView()
		}
	}

	// MARK: - PlaylistPresenterProtocol

	var numberOfSections: Int {
		PlaylistType.allCases.count
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

	func playlist(for indexPath: IndexPath) -> Playlist? {
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
		var selectedPlaylist: Playlist?

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
		guard let playlistType = PlaylistType(rawValue: indexPath.section) else { return }

		switch playlistType {
		case .private:
			guard let playlist = model.privatePlaylist[safe: indexPath.row] else { return }
			guard playlist.createdBy == model.currentUserId else {
				return view.showBasicAlert(message: LocalizedStrings.Playlist.unableToDelete.localized)
			}
			model.privatePlaylistItem.removeValue(for: .withPath(playlist.id))

		case .public:
			guard let playlist = model.publicPlaylist[safe: indexPath.row] else { return }
			guard playlist.createdBy == model.currentUserId else {
				return view.showBasicAlert(message: LocalizedStrings.Playlist.unableToDelete.localized)
			}
			model.publicPlaylistItem.removeValue(for: .withPath(playlist.id))
		}
	}
}
