//
//  FriendsPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for FriendsPresenter.
protocol FriendsPresenterProtocol {
	
	/// Users current user can invite.
	var possibleFriends: [FriendForInvite] { get }
	
	/// Users waiting to be accepted.
	var invitations: [FriendForInvite] { get }
	
	/// Users this user is waiting to accept him.
	var pendingInvitations: [FriendForInvite] { get }
	
	/// Current user's friends.
	var friends: [FriendForInvite] { get }
	
	/// Methodsends invitation to a user.
	func sendInvitation(at index: Int)

	/// Method accepts invitation.
	func acceptInvitation(at index: Int)

	/// Method denies invitation.
	func denyInvitation(at index: Int)
	
	/// Method deletes friend.
	func deleteFriend(at index: Int)
	
	/// Method revokes sent invitation.
	func revokeInvitation(at index: Int)
}
