//
//  FriendsModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for FriendsModel.
protocol FriendsModelProtocol {

	/// Handler that updates view in FriendsView.
	var updateView: (() -> Void)? { get set }

	/// Username of the user.
	var currentUsername: String { get set }

	/// Methodsends invitation to a user.
	func sendInvitation(at index: Int)

	/// Method accepts invitation.
	func acceptInvitation(at index: Int)

	/// Method denies invitation.
	func denyInvitation(at index: Int)
}
