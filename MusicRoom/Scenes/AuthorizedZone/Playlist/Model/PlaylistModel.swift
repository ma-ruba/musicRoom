//
//  PlaylistModel.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAnalytics

// Int value corresponds to the section index
enum PlaylistType: Int, CaseIterable {
	case `private` = 0
	case `public` = 1

	var name: String {
		switch self {
		case .private:
			return "private"

		case .public:
			return "public"
		}
	}

	func toggle() -> Self {
		switch self {
		case .private:
			return .public

		case .public:
			return .private
		}
	}
}

struct PlaylistItem {
	var name: String
	var uid: String
	var type: PlaylistType
}

final class PlaylistModel: PlaylistModelProtocol {
	var privatePlaylist: [PlaylistItem] = [] {
		didSet {
			updateView?()
		}
	}
	var publicPlaylist: [PlaylistItem] = [] {
		didSet {
			updateView?()
		}
	}

	var updateView: (() -> Void)?
	var showError: (() -> Void)?

	private var privatePlaylistItem: DatabaseItem
	private var publicPlaylistItem: DatabaseItem

	init() {
		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		privatePlaylistItem = DatabaseItem(
			path: DatabasePath.user.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue
		)
		publicPlaylistItem = DatabaseItem(path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue)

		fetchData()
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - PlaylistModelProtocol

	func deletePlaylist(at indexPath: IndexPath) {
		guard let playlistType = PlaylistType.init(rawValue: indexPath.section) else { return }

		switch playlistType {
		case .private:
			guard let playlistId = privatePlaylist[safe: indexPath.row]?.uid else { return }
			privatePlaylistItem.reference.child(playlistId).observeSingleEvent(of: .value) { [ weak self] snapshot in
				let playlist = Playlist(snapshot: snapshot)
				guard playlist.createdBy == Auth.auth().currentUser?.uid else {
					self?.showError?()
					return
				}

				self?.privatePlaylistItem.reference.child(playlistId).removeValue()
			}

		case .public:
			guard let playlistId = publicPlaylist[safe: indexPath.row]?.uid else { return }
			publicPlaylistItem.reference.child(playlistId).observeSingleEvent(of: .value) { [ weak self] snapshot in
				let playlist = Playlist(snapshot: snapshot)
				guard playlist.createdBy == Auth.auth().currentUser?.uid else {
					self?.showError?()
					return
				}

				self?.publicPlaylistItem.reference.child(playlistId).removeValue()
			}
		}
	}

	// MARK: - Private

	private func tearDownDatabase() {
		if let handle = privatePlaylistItem.handle {
			privatePlaylistItem.reference.removeObserver(withHandle: handle)
		}

		if let handle = publicPlaylistItem.handle {
			publicPlaylistItem.reference.removeObserver(withHandle: handle)
		}
	}

	private func fetchData() {
		publicPlaylistItem.handle = publicPlaylistItem.reference.observe(.value) { snapshot in
			var playlists: [PlaylistItem] = []
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				guard let ref = playlist.ref, let uid = ref.key else { break }
				playlists.append(PlaylistItem(name: playlist.name, uid: uid, type: .public))
			}

			self.publicPlaylist = playlists
		}

		// TODO: Доделать добавление плейлистов от других юзеров
		privatePlaylistItem.handle = privatePlaylistItem.reference.observe(.value) { snapshot in
			var playlists: [PlaylistItem] = []
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				guard let ref = playlist.ref, let uid = ref.key else { break }
				playlists.append(PlaylistItem(name: playlist.name, uid: uid, type: .private))
			}

			self.privatePlaylist = playlists
		}
	}
}
