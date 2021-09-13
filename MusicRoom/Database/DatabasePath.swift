//
//  DatabasePath.swift
//  MusicRoom
//
//  Created by Mariia on 18.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Enum for constructing path for the data in Firebase
enum DatabasePath: String {
	case users = "users/"
	case `public` = "public/"
	case `private` = "private/"
	case playlists = "playlists/"
	case slash = "/"
	case tracks = "tracks/"
	case orderNumber = "orderNumber/"
	case username = "username/"
	case friends = "friends/"
	case friendInvitations = "friendInvitations/"
	case pendingInvitations = "pendingInvitations/"
	case possibleFriends = "possibleFriends/"
}
