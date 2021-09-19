//
//  MockDatabaseReference.swift
//  MusicRoom
//
//  Created by Mariia on 19.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import XCTest
@testable import MusicRoom

final class MockDatabaseReference: DatabaseReference {

	private var handleValue: UInt = 0
	var expectedValue: Any?

	init(with value: Any) {
		expectedValue = value
	}

	override func child(_ pathString: String) -> DatabaseReference {
		return self
	}

	override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
		let snapshot = MockSnapshot(with: expectedValue)
		DispatchQueue.global().async {
			block(snapshot)
		}
	}

	override func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt {
		let snapshot = MockSnapshot(with: expectedValue)
		DispatchQueue.global().async {
			block(snapshot)
		}

		handleValue += 1

		return handleValue
	}

	override func removeValue(completionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
		DispatchQueue.global().async {
			block(nil, self)
		}
	}
}
