//
//  AddPlaylistPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 23.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class AddPlaylistPresenter: AddPlaylistPresenterProtocol {
	unowned private var view: AddPlaylistViewProtocol
	private var model: AddPlaylistModel

	var numberOfSections: Int {
		return 1
	}

	var isNameFieldEmpty: Bool {
		return model.playlist.name.isEmpty
	}

	init(view: AddPlaylistViewProtocol) {
		self.view = view

		model = AddPlaylistModel()
	}

	// MARK: - AddPlaylistPresenterProtocol

	func numberOfRows(in section: Int) -> Int {
		return 3
	}

	func item(for indexPath: IndexPath) -> AddPlaylistType? {
		return AddPlaylistType(rawValue: indexPath.row) ?? nil
	}

	func updatePlaylistName(with name: String) {
		model.playlist.name = name
	}

	func updatePlaylistType() {
		let playlist = model.playlist
		let newType = playlist.type.toggle()
		model.playlist.type = newType
	}

	func createPlaylist() {
		let playlistType = model.playlist.type

		switch playlistType {
		case .public:
			let publicPlaylistItem = DatabaseItem(
				path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue,
				hasAutoID: true
			)
			guard let playlistId = publicPlaylistItem.key else { return }
			model.playlist.id = playlistId
			publicPlaylistItem.setValue(model.playlist.object) { [weak self] error in
				guard let self = self else { return }
				guard error == nil else { return self.view.showBasicAlert(message: error.debugDescription) }
			}

		case .private:
			let privatePlaylistItem = DatabaseItem(
				path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + model.currentUid + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue,
				hasAutoID: true
			)
			guard let playlistId = privatePlaylistItem.key else { return }
			model.playlist.id = playlistId
			privatePlaylistItem.setValue(model.playlist.object, for: .byAutoId) { [weak self] error in
				guard let self = self else { return }
				guard error == nil else { return self.view.showBasicAlert(message: error.debugDescription) }
			}
		}
	}
}
