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
		model = AddPlaylistModel(playlist: PlaylistItem(name: "", uid: "", type: .public))
	}

	// MARK: - AddPlaylistPresenterProtocol

	func numberOfRows(in section: Int) -> Int {
		return 3
	}

	func item(for indexPath: IndexPath) -> AddPlaylistItemType? {
		return AddPlaylistItemType(rawValue: indexPath.row) ?? nil
	}

	func updatePlaylistName(with name: String) {
		model = AddPlaylistModel(
			playlist: PlaylistItem(name: name, uid: model.playlist.uid, type: model.playlist.type)
		)
	}

	func updatePlaylistType() {
		let playlist = model.playlist
		let newType = playlist.type.toggle()
		model = AddPlaylistModel(
			playlist: PlaylistItem(name: playlist.name, uid: playlist.uid, type: newType)
		)
	}

	func createPlaylist() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let playlist = Playlist(name: model.playlist.name, userId: uid)

		let playlistType = model.playlist.type

		switch playlistType {
		case .public:
			let publicPlaylistRef = Database.database().reference(
				withPath: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue
			).childByAutoId()
			guard let publicPlaylistRefKey = publicPlaylistRef.key else { return }
			publicPlaylistRef.setValue(playlist.publicObject) { error, _ in
				guard error == nil else { return }

				Log.event(
					"created_playlist",
					parameters: [
						"playlist_id": publicPlaylistRefKey,
						"playlist_name": playlist.name,
						"public_or_private": playlistType.name,
					]
				)
			}

		case .private:
			let privatePlaylistRef = Database.database().reference(
				withPath: DatabasePath.user.rawValue + uid + DatabasePath.playlists.rawValue
			).childByAutoId()
			guard let privatePlaylistRefKey = privatePlaylistRef.key else { return }

			privatePlaylistRef.setValue(playlist.publicObject) { error, _ in
				guard error == nil else { return }

				Log.event(
					"created_playlist",
					parameters: [
						"playlist_id": privatePlaylistRefKey,
						"playlist_name": playlist.name,
						"public_or_private": playlistType.name,
					]
				)
			}
		}
	}
}
