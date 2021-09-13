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
			let publicPlaylistRef = Database.database().reference(
				withPath: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue
			).childByAutoId()
			guard let publicPlaylistRefKey = publicPlaylistRef.key else { return }
			model.playlist.id = publicPlaylistRefKey
			publicPlaylistRef.setValue(model.playlist.object) { [weak self] error, _ in
				guard let self = self else { return }
				guard error == nil else { return self.view.showBasicAlert(message: error.debugDescription) }

				Analytics.logEvent(
					"created_playlist",
					parameters: [
						"playlist_id": self.model.playlist.id,
						"playlist_name": self.model.playlist.name,
						"public_or_private": self.model.playlist.type.name,
					]
				)
			}

		case .private:
			let privatePlaylistRef = Database.database().reference(
				withPath: DatabasePath.private.rawValue + DatabasePath.users.rawValue + model.currentUid + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue
			).childByAutoId()
			guard let privatePlaylistRefKey = privatePlaylistRef.key else { return }
			model.playlist.id = privatePlaylistRefKey
			privatePlaylistRef.setValue(model.playlist.object) { [weak self] error, _ in
				guard let self = self else { return }
				guard error == nil else { return self.view.showBasicAlert(message: error.debugDescription) }

				Analytics.logEvent(
					"created_playlist",
					parameters: [
						"playlist_id": self.model.playlist.id,
						"playlist_name": self.model.playlist.name,
						"public_or_private": self.model.playlist.type.name,
					]
				)
			}
		}
	}
}
