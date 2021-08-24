//
//  AddPlaylistPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 23.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol AddPlaylistPresenterProtocol {
	var numberOfSections: Int { get }

	func numberOfRows(in section: Int) -> Int
	func item(for indexPath: IndexPath) -> AddPlaylistItemType
}
