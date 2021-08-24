//
//  PlaylistPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

protocol PlaylistPresenterProtocol {
	var numberOfSections: Int { get }

	func addPlaylist()
	func openPlaylist(at indexPath: IndexPath)
	func deletePlaylist(at indexPath: IndexPath)
	func numberOfRows(in section: Int) -> Int
	func playlist(for indexPath: IndexPath) -> PlaylistItem?
	func typeName(for section: Int) -> String?
}
