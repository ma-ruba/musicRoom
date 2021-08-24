//
//  DatabaseItem.swift
//  MusicRoom
//
//  Created by Mariia on 18.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Firebase

struct DatabaseItem {
	let reference: DatabaseReference
	let path: DatabasePath
	var handle: UInt?

	init(path: DatabasePath, parameter: String = "") {
		self.path = path

		reference = Database.database().reference(withPath: path.rawValue + parameter)
	}
}
