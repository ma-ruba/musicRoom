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
	var possibleFriends: [FriendForInvite] = []

	/// Users waiting to be accepted.
	var invitations: [FriendForInvite] = []

	/// Users this user is waiting to accept him.
	var pendingInvitations: [FriendForInvite] = []

	/// Current user's friends.
	var friends: [FriendForInvite] = []

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

	// MARK: - Private

	private func configureDatabase() {
		usernameItem.observeValueOnce() { [weak self] snapshot in
			guard let username = snapshot.value as? String else { return }

			self?.currentUsername = username
		}

		friendsItem.observeValue { [weak self] snapshot in
			guard let self = self else { return }

			var friends: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let friend = FriendForInvite(snapshot: snap)
				
				friends.append(friend)
			}

			self.friends = friends
			self.updateView?()
		}

		invitationItem.observeValue { [weak self] snapshot in
			guard let self = self else { return }

			var invitations: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let invitation = FriendForInvite(snapshot: snap)
				
				invitations.append(invitation)
			}

			self.invitations = invitations
			self.updateView?()
		}

		pendingInvitationsItem.observeValue { [weak self] snapshot in
			guard let self = self else { return }

			var pendingInvitations: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let pendingInvitation = FriendForInvite(snapshot: snap)
				
				pendingInvitations.append(pendingInvitation)
			}

			self.pendingInvitations = pendingInvitations
			self.updateView?()
		}
		
		possibleFriendsItem.observeValue { [weak self] snapshot in
			guard let self = self else { return }

			var possibleFriends: [FriendForInvite] = []
			
			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot else { break }
				let possibleFriend = FriendForInvite(snapshot: snap)
				
				possibleFriends.append(possibleFriend)
			}

			self.possibleFriends = possibleFriends
			self.updateView?()
		}

		allUsersItem.observeValue { [weak self] snapshot in
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
			self.updateView?()
		}
	}
}
