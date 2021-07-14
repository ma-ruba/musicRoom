//
//  TabBarPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 13.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class TabBarPresenter: TabBarPresenterProtocol {
	unowned private var view: TabBarViewProtocol
	private var model: TabBarModel?

	init(view: TabBarViewProtocol) {
		self.view = view

		model = TabBarModel()
	}

	var viewControllers: [UIViewController] {
		var result: [UIViewController] = []
		guard let model = model else { return result }

		for item in model.items {
			switch item {
			case .settings:
				result.append(SettingsViewController())

			case .events:
				result.append(EventsTableViewController())

			case .playlists:
				result.append(PlaylistTableViewController())
			}
		}

		return result
	}

	var tabBarItems: [TabBarModel.TabBarItem] {
		return model?.items ?? []
	}
}
