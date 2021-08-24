//
//  ReplaceCharactersHelper.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

enum ReplaceCharactersHelper {
	static func replace(inText text: String, range: NSRange, withCharacters newText: String) -> String {
		let result = NSMutableString(string: text)
		// При удалении строки  следим за тем, что в массиве text имеется length символов на удалении начиная с индекса length
		guard range.length + range.location <= text.count else { return result as String }

		if range.length > 0 {
			result.replaceCharacters(in: range, with: newText)
		} else {
			result.insert(newText, at: range.location)
		}
		return result as String
	}
}
