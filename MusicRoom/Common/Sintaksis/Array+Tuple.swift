//
//  Array+Tuple.swift
//  MusicRoom
//
//  Created by Mariia on 30.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

extension Array {
	static func from(_ elements: Element?...) -> [Element] {
		var array: [Element] = []
		for element in elements {
			if let element = element {
				array.append(element)
			}
		}

		return array
	}
}
