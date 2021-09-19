//
//  DatabaseItem.swift
//  MusicRoom
//
//  Created by Mariia on 18.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Firebase

/// Entity for working with Firebase datatabase.
final class DatabaseItem: Equatable {
	var key: String? {
		reference.key
	}

	private var reference: DatabaseReference
	private var handle: UInt?
	private let path: String

	// MARK: Initialization

	/// Method initializes item in database.
	///
	/// - Parameters:
	///   - path: Path of the item in database.
	///   - hasAutoID: Falg that shows if key in keyPath is generated rabdomly.
	init(path: String, hasAutoID: Bool = false) {
		var reference = Database.database().reference(withPath: path)
		var finalPath = path
		if hasAutoID {
			reference = reference.childByAutoId()
			finalPath += reference.key ?? ""
		}

		self.path = finalPath
		self.reference = reference
	}

	deinit {
		removeObserver()
	}

	// MARK: - Internal

	/// Method permanently observes value.
	func observeValue(_ completion: ((DataSnapshot) -> Void)? = nil) {
		reference.observe(.value) { snapshot in
			completion?(snapshot)
		}
	}

	/// Method observes value but as soon as data is received observer removes.
	func observeValueOnce(for child: DatabaseItemChild = .none, _ completion: ((DataSnapshot) -> Void)? = nil) {
		switch child {
		case .byAutoId:
			reference.childByAutoId().observeSingleEvent(of: .value) { snapshot in
				completion?(snapshot)
			}

		case let .withPath(path):
			reference.child(path).observeSingleEvent(of: .value) { snapshot in
				completion?(snapshot)
			}

		case .none:
			reference.observeSingleEvent(of: .value) { snapshot in
				completion?(snapshot)
			}
		}
	}

	/// Method removes value from database.
	func removeValue(for child: DatabaseItemChild = .none, _ completion: ((Error?) -> Void)? = nil) {
		switch child {
		case .byAutoId:
			reference.childByAutoId().removeValue { error, _ in
				completion?(error)
		 }

		case let .withPath(path):
			reference.child(path).removeValue { error, _ in
				completion?(error)
			}

		case .none:
			reference.removeValue { error, _ in
				completion?(error)
			}
		}
	}

	/// Method sets value to database.
	func setValue(_ value: Any, for child: DatabaseItemChild = .none, _ completion: ((Error?) -> Void)? = nil) {
		switch child {
		case .byAutoId:
			reference.childByAutoId().setValue(value) { error, _ in
				completion?(error)
		 }

		case let .withPath(path):
			reference.child(path).setValue(value) { error, _ in
				completion?(error)
			}

		case .none:
			reference.setValue(value) { error, _ in
				completion?(error)
			}
		}
	}

	/// For testing purposes only!
	func setReference(_ reference: DatabaseReference) {
		self.reference = reference
	}

	// MARK: - Private

	private func removeObserver() {
		guard let handle = handle else { return }
		reference.removeObserver(withHandle: handle)
	}

	// MARK: - Equatable

	static func == (lhs: DatabaseItem, rhs: DatabaseItem) -> Bool {
		return lhs.path == rhs.path
	}
}
