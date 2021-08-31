//
//  FriendsPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class FriendsPresenter: FriendsPresenterProtocol {
	unowned private var view: FriendsViewProtocol
	private var model: FriendsModelProtocol?

	var numberOfSections: Int {
		return 4
	}

	// MARK: Initializzation

	init(view: FriendsViewProtocol) {
		self.view = view

		model = FriendsModel()
		model.updateView = { view. }
	}

	// MARK: - FriendsPresenterProtocol
}
