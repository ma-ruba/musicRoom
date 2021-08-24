//
//  PlaylistModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 15.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol PlaylistModelProtocol {
	var updateView: (() -> Void)? { get set }
	var showError: (() -> Void)? { get set }

	var privatePlaylist: [PlaylistItem] { get }
	var publicPlaylist: [PlaylistItem] { get }

	func deletePlaylist(at indexPath: IndexPath)
}
