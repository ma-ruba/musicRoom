//
//  TabBarModel.swift
//  MusicRoom
//
//  Created by Mariia on 13.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

struct TabBarModel {
	enum TabBarItem: String, CaseIterable {
		case playlists
		case settings

		var name: String {
			return self.rawValue.capitalized
		}

		var image: ImageList {
			switch self {
			case .settings:
				return .settings

			case .playlists:
				return .playlists
			}
		}
	}

	var items: [TabBarItem] {
		return TabBarItem.allCases
	}
}
