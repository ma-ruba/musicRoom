//
//  DatabaseItemChild.swift
//  MusicRoom
//
//  Created by 18588255 on 18.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Child for DatabaseItem.
enum DatabaseItemChild: Equatable {

	/// Child is created with path.
	case withPath(String)

	/// Child path is generated randomly.
	case byAutoId

	/// There is no child.
	case none
}
