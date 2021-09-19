//
//  FriendsPresenter.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

final class FriendsPresenter: FriendsPresenterProtocol {
	unowned private var view: FriendsViewProtocol
	private var model: FriendsModelProtocol

	/// Users current user can invite.
	var possibleFriends: [FriendForInvite] {
		model.possibleFriends
	}
	
	/// Users waiting to be accepted.
	var invitations: [FriendForInvite] {
		model.invitations
	}
	
	/// Users this user is waiting to accept him.
	var pendingInvitations: [FriendForInvite] {
		model.pendingInvitations
	}
	
	/// Current user's friends.
	var friends: [FriendForInvite] {
		model.friends
	}

	// MARK: Initializzation

	init(view: FriendsViewProtocol) {
		self.view = view

		model = FriendsModel()
		model.updateView = { [weak self] in
			self?.view.reloadTableView()
		}
	}

	// MARK: - FriendsPresenterProtocol
	
	/// Methodsends invitation to a user.
	func sendInvitation(at index: Int) {
		guard let friend = possibleFriends[safe: index] else {
			return assertionFailure(MusicRoomErrors.BasicErrors.noElementAtIndexFound.localizedDescription)
		}

		// Adding the friend to pending invitations list.
		model.pendingInvitationsItem.setValue(friend.object, for: .withPath(friend.id)) { error in
			guard error == nil else {
				return print(error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription)
			}
		}

		// Deleting the friend from all users list.
		model.possibleFriendsItem.removeValue(for: .withPath(friend.id))

		// Adding current user to the invitations list of the friend.
		let friendItem = DatabaseItem(path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friend.id + DatabasePath.slash.rawValue)
		friendItem.setValue(model.currentUser.object, for: .withPath(DatabasePath.friendInvitations.rawValue + model.currentUid))

		// Deleting current user from all users list of the friend.
		friendItem.removeValue(for: .withPath(DatabasePath.possibleFriends.rawValue + model.currentUid))
	}

	/// Method accepts invitation.
	func acceptInvitation(at index: Int) {
		guard let friend = invitations[safe: index] else {
			return assertionFailure(MusicRoomErrors.BasicErrors.noElementAtIndexFound.localizedDescription)
		}

		// Adding the friend to the list of friends.
		model.friendsItem.setValue(friend.object, for: .withPath(friend.id)) { error in
			guard error == nil else {
				return print(error?.localizedDescription ?? MusicRoomErrors.BasicErrors.somethingWrong.localizedDescription)
			}
		}

		// Deleting the friend from invitations list.
		model.invitationItem.removeValue(for: .withPath(friend.id))

		// Deleting current user from the pending invitations list of the friend.
		let friendItem = DatabaseItem(path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friend.id + DatabasePath.slash.rawValue)
		friendItem.removeValue(for: .withPath(DatabasePath.pendingInvitations.rawValue + model.currentUid))

		// Adding current user to the friends list of the friend.
		friendItem.setValue(model.currentUser.object, for: .withPath(DatabasePath.friends.rawValue + model.currentUid))
	}

	/// Method denies invitation.
	func denyInvitation(at index: Int) {
		guard let friend = invitations[safe: index] else {
			return assertionFailure(MusicRoomErrors.BasicErrors.noElementAtIndexFound.localizedDescription)
		}

		// Deleting the friend from invitations list.
		model.invitationItem.removeValue(for: .withPath(friend.id))

		// Deleting current user from the pending invitations list of the friend.
		let friendItem = DatabaseItem(path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friend.id + DatabasePath.slash.rawValue)
		friendItem.removeValue(for: .withPath(DatabasePath.pendingInvitations.rawValue + model.currentUid))

		// Adding current user to possible friends list of the friend.
		friendItem.setValue(model.currentUser, for: .withPath(DatabasePath.possibleFriends.rawValue + model.currentUid))
	}
	
	/// Method deletes friend.
	func deleteFriend(at index: Int) {
		guard let friend = friends[safe: index] else {
			return assertionFailure(MusicRoomErrors.BasicErrors.noElementAtIndexFound.localizedDescription)
		}

		// Deleting the friend from the list of friends.
		model.friendsItem.removeValue(for: .withPath(friend.id))

		// Adding the friend to the possible friends list.
		model.possibleFriendsItem.setValue(friend.object, for: .withPath(friend.id))

		// Deleting current user from the list of friends of the friend.
		let friendItem = DatabaseItem(path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friend.id + DatabasePath.slash.rawValue)
		friendItem.removeValue(for: .withPath(DatabasePath.friends.rawValue + model.currentUid))

		// Adding current user to the possible friends list of the friend.
		friendItem.setValue(model.currentUser.object, for: .withPath(DatabasePath.possibleFriends.rawValue + model.currentUid))
	}
	
	/// Method revokes sent invitation.
	func revokeInvitation(at index: Int) {
		guard let friend = pendingInvitations[safe: index] else {
			return assertionFailure(MusicRoomErrors.BasicErrors.noElementAtIndexFound.localizedDescription)
		}

		// Deleting the friend from the pending invitations list.
		model.pendingInvitationsItem.removeValue(for: .withPath(friend.id))

		// Adding the friend to the possible friends list.
		model.possibleFriendsItem.setValue(friend.object, for: .withPath(friend.id))

		// Deleting current user from the invitations list of the friend.
		let friendItem = DatabaseItem(path: DatabasePath.private.rawValue + DatabasePath.users.rawValue + friend.id + DatabasePath.slash.rawValue)
		friendItem.removeValue(for: .withPath(DatabasePath.friendInvitations.rawValue + model.currentUid))

		// Adding current user ti the possible friends list of the friend.
		friendItem.setValue(model.currentUser.object, for: .withPath(DatabasePath.possibleFriends.rawValue + model.currentUid))
	}
}
