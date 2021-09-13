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

final class PlaylistModel: PlaylistModelProtocol {
	var privatePlaylist: [Playlist] = [] {
		didSet {
			updateView?()
		}
	}
	var publicPlaylist: [Playlist] = [] {
		didSet {
			updateView?()
		}
	}

	var updateView: (() -> Void)?

	var privatePlaylistItem: DatabaseItem
	var publicPlaylistItem: DatabaseItem
	private var friendsItem: DatabaseItem

	init() {
		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		privatePlaylistItem = DatabaseItem(
			path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue
		)
		publicPlaylistItem = DatabaseItem(path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue)

		friendsItem = DatabaseItem(
			path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.friends.rawValue
		)

		fetchData()
	}

	deinit {
		tearDownDatabase()
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
		publicPlaylistItem.handle = publicPlaylistItem.reference.observe(.value) { [weak self] snapshot in
			self?.publicPlaylist.removeAll()

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				self?.publicPlaylist.append(playlist)
			}
		}

		// TODO: Доделать добавление плейлистов от других юзеров
		privatePlaylistItem.handle = privatePlaylistItem.reference.observe(.value) { [weak self] snapshot in
			self?.privatePlaylist.removeAll()

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				self?.privatePlaylist.append(playlist)
			}
		}

//		friendsItem.handle = friendsItem.reference.observe(.value) { snapshot in
//			for snap in snapshot.children {
//				guard let snap = snap as? DataSnapshot else { break }
//				let friendId = FriendForInvite(snapshot: snap).id
//			}
//		}
	}
}
