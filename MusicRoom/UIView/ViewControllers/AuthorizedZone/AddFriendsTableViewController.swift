//
//  AddFriendsTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 03.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class AddFriendsTableViewController: UITableViewController {

	var firebasePath: String?
	var eventOrPlaylistRef: DatabaseReference?
	var eventOrPlaylistHandle: UInt?

	var publicEvent: Bool?
	var from: String?
	var name: String?
	var createdBy: String?
	var friends: [String: String] = [:] {
		didSet {
			tableView.reloadData()
		}
	}
	var invited: [String: Bool] = [:] {
		didSet {
			tableView.reloadData()
		}
	}
	var invitedUsers: [(id: String, name: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var uninvitedFriends: [(id: String, name: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	var requestedUsernames: [String: Bool] = [:] {
		didSet {
			tableView.reloadData()
		}
	}
	var usernames: [String: String] = [:] {
		didSet {
			tableView.reloadData()
		}
	}

	// MARK: Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		if publicEvent == true {
			navigationItem.title = "Delegate Control"
		} else {
			navigationItem.title = "Add friends"
		}


		configureTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		configureDatabase()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if let eventOrPlaylistHandle = eventOrPlaylistHandle {
			eventOrPlaylistRef?.removeObserver(withHandle: eventOrPlaylistHandle)
		}
	}

	// MARK: Private

	private func configureTableView() {
		tableView.registerReusable(cellClass: TextAndButtonTableViewCell.self)
	}

	private func updateFriends() {
		var invitedUsers = [(id: String, name: String)]()
		for userId in invited.keys {
			if userId == Auth.auth().currentUser?.uid {
				continue
			}

			var username = ""
			if let name = friends[userId] {
				username = name
			} else if let name = usernames[userId] {
				username = name
			}
			invitedUsers.append((id: userId, name: username))
		}

		var uninvitedFriends = [(id: String, name: String)]()

		for friend in friends {
			if invited[friend.key] == nil, friend.key != createdBy {
				uninvitedFriends.append((id: friend.key, name: friend.value))
			}
		}

		self.invitedUsers = invitedUsers
		self.uninvitedFriends = uninvitedFriends
		tableView.reloadData()
	}


	private func configureDatabase() {
		guard let uid = Auth.auth().currentUser?.uid, let path = self.firebasePath else {
			return
		}
		eventOrPlaylistRef = Database.database().reference(withPath: path)
		let userRef = Database.database().reference(withPath: "users/" + uid)

		userRef.observeSingleEvent(of: .value, with: { snapshot in
			if let friends = User(snapshot: snapshot).friends {
				self.friends = friends
				self.updateFriends()
			}
		})

		self.eventOrPlaylistHandle = self.eventOrPlaylistRef?.child("userIds").observe(.value, with: { snapshot in
			if let invited = snapshot.value as? [String:Bool] {
				self.invited = invited
			} else {
				self.invited = [:]
			}

			for userEntry in self.invited {
				if self.requestedUsernames[userEntry.key] == nil {
					let ref = Database.database().reference(withPath: "users/\(userEntry.key)/username")

					ref.observeSingleEvent(of: .value, with: { snapshot in
						if let username = snapshot.value as? String {
							self.usernames[userEntry.key] = username
							self.updateFriends()
						}
					})
				}
			}

			self.updateFriends()
		})
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {

		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return invitedUsers.isEmpty ? 1 : invitedUsers.count

		case 1:
			return uninvitedFriends.isEmpty ? 1 : uninvitedFriends.count

		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			if publicEvent == true {
				return "Delegated Control"
			} else {
				return "Collaborators"
			}

		case 1:
			if publicEvent == true {
				return "Invite to Control"
			} else {
				return "Uninvited"
			}

		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: TextAndButtonTableViewCell.self, for: indexPath)
		cell.deezerButton.isHidden = true
		cell.buttonLabel.isHidden = true
		cell.button.isHidden = false

		switch indexPath.section {
		case 0:
			if invitedUsers.isEmpty {
				if publicEvent == true { cell.textedLabel.text = "No friends have delegation control" }
				else { cell.textedLabel.text = "No friends added yet - add some below!" }
				cell.textedLabel.textColor = .gray
			} else {
				cell.textedLabel.text = invitedUsers[indexPath.row].name
				cell.textedLabel.textColor = .black
			}

		case 1:
			if uninvitedFriends.isEmpty {
				if friends.isEmpty { cell.textedLabel.text = "You do not have any friends yet!" }
				else { cell.textedLabel.text = "No mo friends to show" }
				cell.textedLabel.textColor = .gray
			} else {
				cell.textedLabel.text = uninvitedFriends[indexPath.row].name
				cell.textedLabel.textColor = .black
				cell.button.addTarget(self, action: #selector(addFriend(sender:)), for: .touchUpInside)
				cell.button.setImage(UIImage(name: .add), for: .normal)
				cell.button.tag = indexPath.row
			}


		default:
			return UITableViewCell()
		}

		return cell
	}

	// MARK: - Actions

	@objc private func addFriend(sender: Any) {
		guard let button = sender as? UIButton else { return }

		if let from = self.from, let name = self.name, let eventOrPlaylistRef = self.eventOrPlaylistRef,
			let eventOrPlaylistRefKey = eventOrPlaylistRef.key {
			if publicEvent == true {
				let publicEventRef = Database.database().reference(withPath: "events/public/\(eventOrPlaylistRef.key)/userIds/\(uninvitedFriends[button.tag].id)")
				publicEventRef.setValue(true)
				return
			}

			let addingUserId = uninvitedFriends[button.tag].id
			let addFriend: [String: Any] = [
				"users/\(addingUserId)/\(from)s/\(eventOrPlaylistRef.key)": name,
				"\(from)s/private/\(eventOrPlaylistRef.key)/userIds/\(addingUserId)": true,
			]

			let ref = Database.database().reference()
			ref.updateChildValues(addFriend, withCompletionBlock: { (error, ref) -> Void in
				if error == nil {
					Log.event("added_friend_to_playable", parameters: [
						"playable_type": from,
						"playable_id": eventOrPlaylistRefKey,
						"added_user": addingUserId,
					])
				}
			})
		}
		configureDatabase()
	}
}
