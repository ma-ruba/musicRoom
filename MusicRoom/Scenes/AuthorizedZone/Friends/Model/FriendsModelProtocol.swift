//
//  FriendsModelProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for FriendsModel.
protocol FriendsModelProtocol {

	///
	var friendsItem: DatabaseItem { get }

	///
	var invitationItem: DatabaseItem { get }

	///
	var pendingInvitationsItem: DatabaseItem { get }

	///
	var possibleFriendsItem: DatabaseItem { get }

	///
	var currentUid: String { get }

	///
	var currentUser: FriendForInvite { get }

	/// Handler that updates view in FriendsView.
	var updateView: (() -> Void)? { get set }

	/// Username of the user.
	var currentUsername: String { get set }
	
	/// Users current user can invite.
	var possibleFriends: [FriendForInvite] { get }
	
	/// Users waiting to be accepted.
	var invitations: [FriendForInvite] { get }
	
	/// Users this user is waiting to accept him.
	var pendingInvitations: [FriendForInvite] { get }
	
	/// Current user's friends.
	var friends: [FriendForInvite] { get }
}
