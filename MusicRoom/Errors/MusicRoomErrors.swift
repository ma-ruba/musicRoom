//
//  MusicRoomErrors.swift
//  MusicRoom
//
//  Created by Mariia on 18.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//
enum MusicRoomErrors {
	enum DeletingPlaylistError: Error {
		case noUser
	}

	enum BasicErrors: Error {
		case somethingWrong
	}
}
