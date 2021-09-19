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

final class PlaylistModel: PlaylistModelProtocol {

	var privatePlaylist: [Playlist] {
		myFriendsPlaylists + myPrivatePlaylists
	}

	var publicPlaylist: [Playlist] = [] {
		didSet {
			updateView?()
		}
	}

	private var myFriendsPlaylists: [Playlist] = [] {
		didSet {
			updateView?()
		}
	}

	private var myPrivatePlaylists: [Playlist] = [] {
		didSet {
			updateView?()
		}
	}

	let currentUserId: String

	var updateView: (() -> Void)?
	var privatePlaylistItem: DatabaseItem
	var publicPlaylistItem: DatabaseItem

	private var friendsItem: DatabaseItem

	init() {
		guard let userId = Auth.auth().currentUser?.uid else {
			fatalError(LocalizedStrings.AssertationErrors.noUser.localized)
		}

		currentUserId = userId

		privatePlaylistItem = DatabaseItem(
			path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue
		)
		publicPlaylistItem = DatabaseItem(path: DatabasePath.public.rawValue + DatabasePath.playlists.rawValue)

		friendsItem = DatabaseItem(
			path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + userId + DatabasePath.slash.rawValue + DatabasePath.friends.rawValue
		)

		fetchData()
	}

	// MARK: - Private

	private func fetchData() {
		publicPlaylistItem.observeValue { [weak self] snapshot in
			var playlists: [Playlist] = []

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				playlists.append(playlist)
			}

			self?.publicPlaylist = playlists
		}

		privatePlaylistItem.observeValue { [weak self] snapshot in
			var playlists: [Playlist] = []

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let playlist = Playlist(snapshot: snap)

				playlists.append(playlist)
			}

			self?.myPrivatePlaylists = playlists
		}

		// Adding to the current user's private playlists private playlist of his friends.
		friendsItem.observeValue { [weak self] snapshot in
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let friendId = snap.key
				guard friendId != self?.currentUserId else { return }
				let playlistsItem = DatabaseItem(
					path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friendId
						+ DatabasePath.slash.rawValue + DatabasePath.playlists.rawValue
				)
				playlistsItem.observeValue { [weak self] snapshot in
					var playlists: [Playlist] = []

					for snap in snapshot.children {
						guard let snap = snap as? DataSnapshot else { break }
						let playlist = Playlist(snapshot: snap)
						playlists.append(playlist)
					}

					self?.myFriendsPlaylists = playlists
				}
			}
		}
	}
}
