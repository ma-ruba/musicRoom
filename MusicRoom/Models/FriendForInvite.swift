//
//  FriendForInvite.swift
//  MusicRoom
//
//  Created by Mariia on 02.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Entity that describes a different user as an invitation subject.
struct FriendForInvite: Equatable {
	
	/// Keys for data in object property.
	private enum Key: String {
		case username
		case id
	}
	
	/// Id of the user.
	var id: String = ""
	
	/// User's username.
	var username: String = ""
	
	/// Representation of entity in database.
	var object: [String: Any] {
		[
			Key.id.rawValue: id,
			Key.username.rawValue: username
		]
	}
	
	// MARK: Initialization
	
	init(id: String, username: String) {
		self.id = id
		self.username = username
	}
	
	init(snapshot: DataSnapshot) {
		guard let snapshotValue = snapshot.value as? [String: Any] else { return }
		
		guard let id = snapshotValue[Key.id.rawValue] as? String  else { return }
		self.id = id
		
		guard let username = snapshotValue[Key.username.rawValue] as? String  else { return }
		self.username = username
	}
}
