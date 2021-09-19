//
//  PlaylistType.swift
//  MusicRoom
//
//  Created by 18588255 on 17.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

// Int value corresponds to the section index
enum PlaylistType: Int, CaseIterable {
	case `private` = 0
	case `public` = 1

	var name: String {
		switch self {
		case .private:
			return "private"

		case .public:
			return "public"
		}
	}

	func toggle() -> Self {
		switch self {
		case .private:
			return .public

		case .public:
			return .private
		}
	}
}
