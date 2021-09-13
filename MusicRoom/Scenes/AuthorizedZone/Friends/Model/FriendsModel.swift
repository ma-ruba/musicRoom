//
//  FriendsModel.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import FirebaseAnalytics

final class FriendsModel: FriendsModelProtocol {
	var updateView: (() -> Void)?

	var currentUsername: String = ""

	/// Users current user can invite.
	var possibleFriends: [FriendForInvite] = [] {
		didSet {
			updateView?()
		}
	}

	/// Users waiting to be accepted.
	var invitations: [FriendForInvite] = [] {
		didSet {
			updateView?()
		}
	}

	/// Users this user is waiting to accept him.
	var pendingInvitations: [FriendForInvite] = [] {
		didSet {
			updateView?()
		}
	}

	/// Current user's friends.
	var friends: [FriendForInvite] = [] {
		didSet {
			updateView?()
		}
	}

	var friendsItem: DatabaseItem
	var invitationItem: DatabaseItem
	var pendingInvitationsItem: DatabaseItem
	var possibleFriendsItem: DatabaseItem

	var currentUid: String

	var currentUser: FriendForInvite {
		FriendForInvite(id: currentUid, username: currentUsername)
	}

	private var usernameItem: DatabaseItem
	private var allUsersItem: DatabaseItem

	// MARK: Initialization

	init() {
		guard let uid = Auth.auth().currentUser?.uid else { fatalError(LocalizedStrings.AssertationErrors.noUser.localized) }
		currentUid = uid
		let userPath = DatabasePath.private.rawValue + DatabasePath.users.rawValue + uid + DatabasePath.slash.rawValue
		friendsItem = DatabaseItem(
			path: userPath + DatabasePath.friends.rawValue
		)

		usernameItem = DatabaseItem(
			path: userPath + DatabasePath.username.rawValue
		)

		invitationItem = DatabaseItem(
			path: userPath + DatabasePath.friendInvitations.rawValue
		)

		pendingInvitationsItem = DatabaseItem(
			path: userPath + DatabasePath.pendingInvitations.rawValue
		)

		possibleFriendsItem = DatabaseItem(
			path: userPath + DatabasePath.possibleFriends.rawValue
		)
		
		allUsersItem = DatabaseItem(
			path: DatabasePath.private.rawValue + DatabasePath.users.rawValue
		)

		configureDatabase()
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - Private

	private func tearDownDatabase() {
		if let handle = friendsItem.handle {
			friendsItem.reference.removeObserver(withHandle: handle)
		}

		if let handle = invitationItem.handle {
			invitationItem.reference.removeObserver(withHandle: handle)
		}

		if let handle = pendingInvitationsItem.handle {
			pendingInvitationsItem.reference.removeObserver(withHandle: handle)
		}

		if let handle = possibleFriendsItem.handle {
			possibleFriendsItem.reference.removeObserver(withHandle: handle)
		}
	}

	private func configureDatabase() {
		usernameItem.reference.observeSingleEvent(of: .value) { [weak self] snapshot in
			guard let username = snapshot.value as? String else { return }

			self?.currentUsername = username
		}

		friendsItem.handle = friendsItem.reference.observe(.value) { [weak self] snapshot in
			guard let self = self else { return }

			var friends: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let friend = FriendForInvite(snapshot: snap)
				
				friends.append(friend)
			}

			self.friends = friends
		}

		invitationItem.handle = invitationItem.reference.observe(.value) { [weak self] snapshot in
			guard let self = self else { return }

			var invitations: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let invitation = FriendForInvite(snapshot: snap)
				
				invitations.append(invitation)
			}

			self.invitations = invitations
		}

		pendingInvitationsItem.handle = pendingInvitationsItem.reference.observe(.value) { [weak self] snapshot in
			guard let self = self else { return }

			var pendingInvitations: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let pendingInvitation = FriendForInvite(snapshot: snap)
				
				pendingInvitations.append(pendingInvitation)
			}

			self.pendingInvitations = pendingInvitations
		}
		
		possibleFriendsItem.handle = possibleFriendsItem.reference.observe(.value) { [weak self] snapshot in
			guard let self = self else { return }

			var possibleFriends: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let possibleFriend = FriendForInvite(snapshot: snap)
				
				possibleFriends.append(possibleFriend)
			}

			self.possibleFriends = possibleFriends
		}

		allUsersItem.handle = allUsersItem.reference.observe(.value) { [weak self] snapshot in
			guard let self = self else { return }
			var allUsers: [FriendForInvite] = []

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot,
					let snapValue = snap.value as? [String: String],
					let username = snapValue["username"]
				else { break }

				let userId = snap.key
				
				let friend = FriendForInvite(id: userId, username: username)
				allUsers.append(friend)
			}

			self.possibleFriends.append(
				contentsOf: allUsers.filter {
					!(
						self.friends.contains($0)
						|| self.invitations.contains($0)
						|| self.pendingInvitations.contains($0)
						|| self.possibleFriends.contains($0)
						|| self.currentUid == $0.id
					)
				}
			)
		}
	}
}
