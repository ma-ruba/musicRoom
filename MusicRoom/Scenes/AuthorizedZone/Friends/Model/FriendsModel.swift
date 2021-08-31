//
//  FriendsModel.swift
//  MusicRoom
//
//  Created by Mariia on 31.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

struct Friend: Equatable {
	let id: String
	let username: String
}

final class FriendsModel: FriendsModelProtocol {
	var updateView: (() -> Void)?

	var currentUsername: String = ""

	/// Users this user can invite.
	var allUsers: [Friend] = [] {
		didSet {
			updateView?()
		}
	}

	/// Users waiting for me to accept  their invitation.
	var invitations: [Friend] = [] {
		didSet {
			updateView?()
		}
	}

	/// Users I have invited, but still waiting for the reply.
	var pendingInvitations: [Friend] = [] {
		didSet {
			updateView?()
		}
	}

	/// User's friends
	var friends: [Friend] = [] {
		didSet {
			updateView?()
		}
	}

	private var friendsItem: DatabaseItem
	private var invitationItem: DatabaseItem
	private var pendingInvitationsItem: DatabaseItem
	private var usernameItem: DatabaseItem
	private var usersItem: DatabaseItem

	private var currentUid: String

	// MARK: Initializzation

	init() {
		guard let uid = Auth.auth().currentUser?.uid else { fatalError(LocalizedStrings.AssertationErrors.noUser.localized) }
		currentUid = uid
		let userPath = DatabasePath.user.rawValue + uid + DatabasePath.slash.rawValue
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

		usersItem = DatabaseItem(
			path: DatabasePath.user.rawValue
		)

		configureDatabase()
	}

	deinit {
		tearDownDatabase()
	}

	// MARK: - FriendsModelProtocol

	func acceptInvitation(at index: Int) {
		guard let friend = invitations[safe: index] else { return }
		let newFriendRef = friendsItem.reference.childByAutoId()

		let object: [String: Any] = [friend.id: friend.username]
		newFriendRef.setValue(object) { error, _ in
			guard error == nil else { return }

			Analytics.logEvent("added_a_friend", parameters: Log.defaultInfo())
		}
	}

	func denyInvitation(at index: Int) {
		
	}

	func sendInvitation(at index: Int) {

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

		if let handle = usersItem.handle {
			usersItem.reference.removeObserver(withHandle: handle)
		}
	}

	private func configureDatabase() {
		usernameItem.reference.observeSingleEvent(of: .value) { [weak self] snapshot in
			guard let username = snapshot.value as? String else { return }

			self?.currentUsername = username
		}

		friendsItem.handle = friendsItem.reference.observe(.value) { [weak self ] snapshot in
			guard let self = self else { return }
			guard let allFriends = snapshot.value as? [String: String] else { return self.friends = [] }

			for friend in allFriends {
				self.friends.append(Friend(id: friend.key, username: friend.value))
			}
		}

		invitationItem.handle = invitationItem.reference.observe(.value) { [weak self ] snapshot in
			guard let self = self else { return }
			guard let allInvitations = snapshot.value as? [String: String] else { return self.invitations = [] }

			for invitation in allInvitations {
				self.invitations.append(Friend(id: invitation.key, username: invitation.value))
			}
		}

		pendingInvitationsItem.handle = pendingInvitationsItem.reference.observe(.value) { [weak self ] snapshot in
			guard let self = self else { return }
			guard let allPendingInvitations = snapshot.value as? [String: String] else { return self.pendingInvitations = [] }

			for invitation in allPendingInvitations {
				self.pendingInvitations.append(Friend(id: invitation.key, username: invitation.value))
			}
		}

		usersItem.handle = usersItem.reference.observe(.childChanged) { [weak self ] snapshot in
			guard let self = self else { return }
			var allUsers: [Friend] = []

			for snap in snapshot.children {
				guard let snap = snap as? DataSnapshot,
					let userId = snap.value as? String,
					let username = snap.value(forKeyPath: DatabasePath.username.rawValue) as? String
					else { break }

				let friend = Friend(id: userId, username: username)
				allUsers.append(friend)
			}

			self.allUsers = allUsers.filter { !(self.friends.contains($0) && self.invitations.contains($0) && self.pendingInvitations.contains($0) && self.currentUid == $0.id) }
		}
	}
}
