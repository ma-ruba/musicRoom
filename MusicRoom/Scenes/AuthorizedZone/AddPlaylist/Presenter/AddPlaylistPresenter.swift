//
//  AddPlaylistPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 23.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class AddPlaylistPresenter: AddPlaylistPresenterProtocol {
	unowned private var view: AddPlaylistViewProtocol
	private var model: AddPlaylistModel?

	var numberOfSections: Int {
		return 1
	}

	init(view: AddPlaylistViewProtocol) {
		self.view = view
	}

	// MARK: - AddPlaylistPresenterProtocol

	func numberOfRows(in section: Int) -> Int {
		return 3
	}

	func item(for indexPath: IndexPath) -> AddPlaylistItemType {
		return AddPlaylistItemType(rawValue: indexPath.row) ?? .unnown
	}
}
