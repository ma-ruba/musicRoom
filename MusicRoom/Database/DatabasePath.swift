//
//  DatabasePath.swift
//  MusicRoom
//
//  Created by Mariia on 18.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Enum for constructing path for the data in Firebase
enum DatabasePath: String {
	case user = "users/"
	case `private` = "private/"
	case `public` = "public/"
	case playlists = "playlists/"
}
