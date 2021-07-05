//
//  ForgotPresenter.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class ForgotPresenter: ForgotPresenterProtocol {
	unowned private var view: ForgotViewProtocol
	private var model: ForgotModel?

	init(view: ForgotViewProtocol) {
		self.view = view

		model = nil
	}

	// MARK: - ForgotPresenterProtocol
}
