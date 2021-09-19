//
//  MockSnapshot.swift
//  MusicRoomTests
//
//  Created by 18588255 on 19.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import XCTest
@testable import MusicRoom

final class MockSnapshot: DataSnapshot {
	let newValue: Any?

	init(with value: Any?) {
		newValue = value
	}

	override var value: Any? {
		return newValue
	}
}

