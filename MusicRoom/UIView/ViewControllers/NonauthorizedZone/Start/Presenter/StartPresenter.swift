//
//  StartPresenter.swift
//  MusicRoom
//
//  Created by Мария on 04.06.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class StartPresenter: StartPresenterProtocol {
	unowned private var view: StartViewProtocol
	private let model: StartModel?

	init(view: StartViewProtocol) {
		self.view = view

		model = nil
	}

	func logIn() {
		guard let view = view as? StartViewController else { return }
		let logViewController = LogViewController()

		view.navigationController?.pushViewController(logViewController, animated: true)
	}

	func signUp() {
		guard let view = view as? StartViewController else { return }

		let signViewController = SignViewController()
		view.navigationController?.pushViewController(signViewController, animated: true)
	}
}
