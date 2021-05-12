//
//  FriendsViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 07.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private(set) lazy var tableView = UITableView()

	var friendsRef: DatabaseReference?
	var invitationsRef: DatabaseReference?
	var usernamesRef: DatabaseReference?
	var pendingInvitationsRef: DatabaseReference?

	var friendsHandle: UInt?
	var invitationsHandle: UInt?
	var usernamesHandle: UInt?
	var pendingInvitationsHandle: UInt?

	var myUsername : String?
	var uid: String?

	var usernamesSnapshot = [String:String]()
	var friendsSnapshot = [String:String]()
	var pendingInvitationsSnapshot = [String:String]()
	var invitationsSnapshot = [String:String]()

	var filteredUsernames: [(id: String, username: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var invitations: [(id: String, username: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var pendingInvitations: [(id: String, username: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var friends: [(id: String, username: String)] = [] {
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

		navigationItem.title = "Friends"

		configureDatabase()
		setupTableView()
		configureTableView()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if let invitationsHandle = invitationsHandle {
			invitationsRef?.removeObserver(withHandle: invitationsHandle)
		}
		if let friendsHandle = friendsHandle {
			friendsRef?.removeObserver(withHandle: friendsHandle)
		}
		if let usernamesHandle = usernamesHandle {
			usernamesRef?.removeObserver(withHandle: usernamesHandle)
		}
		if let pendingInvitationsHandle = pendingInvitationsHandle {
			pendingInvitationsRef?.removeObserver(withHandle: pendingInvitationsHandle)
		}
	}

	// MARK: - Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return friends.count

		case 1:
			return invitations.count

		case 2:
			return pendingInvitations.count

		default:
			return filteredUsernames.count
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			if friends.count > 0 { return "Friends" }

		case 1:
			if invitations.count > 0 { return "Invitations" }

		case 2:
			if pendingInvitations.count > 0 { return "Pending Invitations" }

		case 3:
			if filteredUsernames.count > 0 { return "Add Friends" }

		default:
			return nil
		}
		return nil
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: FriendsTableViewCell.self, for: indexPath)

		switch indexPath.section {
		case 0:
			cell.label.text = friends[indexPath.row].username
			cell.acceptButton.isHidden = true
			cell.denyButton.isHidden = true
			cell.addButton.isHidden = true
			return cell

		case 1:
			cell.label.text = invitations[indexPath.row].username
			cell.acceptButton.isHidden = false
			cell.denyButton.isHidden = false
			cell.addButton.isHidden = true
			cell.acceptButton.tag = indexPath.row
			cell.denyButton.tag = indexPath.row
			cell.acceptButton.addTarget(self, action: #selector(acceptInvitation(sender:)), for: .touchUpInside)
			cell.denyButton.addTarget(self, action: #selector(rejectInvitation(sender:)), for: .touchUpInside)
			return cell

		case 2:
			cell.label.text = pendingInvitations[indexPath.row].username
			cell.acceptButton.isHidden = true
			cell.denyButton.isHidden = true
			cell.addButton.isHidden = true
			return cell

		case 3:
			cell.label.text = filteredUsernames[indexPath.row].username
			cell.acceptButton.isHidden = true
			cell.denyButton.isHidden = true
			cell.addButton.isHidden = false
			cell.addButton.tag = indexPath.row
			cell.addButton.addTarget(self, action: #selector(addFriend(sender:)), for: .touchUpInside)
			return cell

		default:
			return UITableViewCell()
		}

	}

	// MARK: - TableViewDelegate

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		switch indexPath.section {
		case 0:
			return true

		default:
			return false
		}
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			deleteFriend(row: indexPath.row)
		}
	}

	// MARK: Private

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.remakeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.right.left.equalTo(view)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}

	private func configureTableView() {
		tableView.registerReusable(cellClass: FriendsTableViewCell.self)
		tableView.estimatedRowHeight = 64
		tableView.delegate = self
		tableView.dataSource = self
	}

	private func deleteFriend(row : Int) {
		guard let uid = Auth.auth().currentUser?.uid else {
			return
		}

		let deleteFriend = [
			"\(self.friends[row].id)/friends/\(uid)": NSNull(),
			"\(uid)/friends/\(self.friends[row].id)": NSNull()
			] as [String : Any]

		updateMultipleUserValues(updatedValues: deleteFriend)
		Analytics.logEvent("deleted_a_friend", parameters: Log.defaultInfo())
	}

	private func updateMultipleUserValues(updatedValues : [String: Any]) {
		let ref = Database.database().reference(withPath: "users/")

		ref.updateChildValues(updatedValues, withCompletionBlock: { (error, ref) -> Void in
//			if error != nil {
//				showBasicAlert(message: "There was a problem")
//			}
		})
	}

	private func configureDatabase() {
		guard let uid = Auth.auth().currentUser?.uid else {
			return
		}

		let ref = Database.database().reference(withPath: "users/\(uid)/username")
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			if let username = snapshot.value as? String {
				self.myUsername = username
			}
		}) { (error) in
			self.showBasicAlert(title: "Username error", message: "Username not found")
		}

		self.friendsRef = Database.database().reference(withPath: "users/" + uid + "/friends")
		self.invitationsRef = Database.database().reference(withPath: "users/" + uid + "/friendInvitations")
		self.pendingInvitationsRef = Database.database().reference(withPath: "users/" + uid + "/pendingInvitations")
		self.usernamesRef = Database.database().reference(withPath: "usernames")

		friendsHandle = self.friendsRef?.observe(.value, with: { snapshot in
			var friends = [(id: String, username: String)]()

			if let allFriends = snapshot.value as? [String:String] {
				self.friendsSnapshot = allFriends

				for friend in allFriends {
					friends.append((id: friend.key, username: friend.value))
				}
			} else {
				self.friendsSnapshot = [String:String]()
			}
			self.friends = friends
//			self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
			self.updateUsernames()
		})

		invitationsHandle = self.invitationsRef?.observe(.value, with: { snapshot in
			var invitations = [(id: String, username: String)]()

			if let allInvitations = snapshot.value as? [String:String] {
				self.invitationsSnapshot = allInvitations

				for invite in allInvitations {
					invitations.append((id: invite.key, username: invite.value))
				}
			} else {
				self.invitationsSnapshot = [String:String]()
			}
			self.invitations = invitations
//			self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
			self.updateUsernames()
		})

		usernamesHandle = self.usernamesRef?.observe(.value, with: { snapshot in
			if let usernamesSnapshot = snapshot.value as? [String:String] {
				self.usernamesSnapshot = usernamesSnapshot
			} else {
				self.usernamesSnapshot = [String:String]()
			}

			self.updateUsernames()
		})

		pendingInvitationsHandle = self.pendingInvitationsRef?.observe(.value, with: { snapshot in
			var pendingInvitations = [(id: String, username: String)]()
			if let allPendingInvitations = snapshot.value as? [String:String] {
				self.pendingInvitationsSnapshot = allPendingInvitations
				for pendingInvite in allPendingInvitations {
					pendingInvitations.append((id: pendingInvite.key, username: pendingInvite.value))
				}
			} else {
				self.pendingInvitationsSnapshot = [String:String]()
			}
			self.pendingInvitations = pendingInvitations
//			self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
			self.updateUsernames()
		})
	}

	private func updateUsernames() {
		let filteredUsernames = usernamesSnapshot.filter { username in
			if username.key != self.myUsername,
				self.friendsSnapshot[username.value] == nil,
				self.invitationsSnapshot[username.value] == nil,
				self.pendingInvitationsSnapshot[username.value] == nil
			{
				return true
			}
			return false
		}

		var filtered = [(id: String, username: String)]()
		for username in filteredUsernames {
			filtered.append((id: username.value, username: username.key))
		}

		self.filteredUsernames = filtered
//		self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
	}

	// MARK: - Actions

	@objc private func goBack() {
		dismiss(animated: true, completion: nil)
	}

	@objc private func acceptInvitation(sender: Any) {
		guard let uid = Auth.auth().currentUser?.uid,
			let username = myUsername,
			let button = sender as? UIButton
		else { return }

		let acceptInvitation = [
			"\(uid)/friends/\(self.invitations[button.tag].id)": self.invitations[button.tag].username,
			"\(self.invitations[button.tag].id)/friends/\(uid)": username,
			"\(uid)/friendInvitations/\(self.invitations[button.tag].id)": NSNull(),
			"\(self.invitations[button.tag].id)/pendingInvitations/\(uid)": NSNull()
			] as [String : Any]

		updateMultipleUserValues(updatedValues: acceptInvitation)
		Analytics.logEvent("accepted_invitation", parameters: Log.defaultInfo())
	}

	@objc private func rejectInvitation(sender: Any) {
		guard let uid = Auth.auth().currentUser?.uid, let button = sender as? UIButton else { return }

		let rejectInvitation = ["\(self.invitations[button.tag].id)/pendingInvitations/\(uid)": NSNull(), "\(uid)/friendInvitations/\(self.invitations[button.tag].id)": NSNull()] as [String : Any]

		updateMultipleUserValues(updatedValues: rejectInvitation)
		Analytics.logEvent("rejected_a_invitation", parameters: Log.defaultInfo())
	}

	@objc func addFriend(sender: Any) {
		guard let uid = Auth.auth().currentUser?.uid, let username = self.myUsername, let button = sender as? UIButton else { return }

		let addFriend = [
			"\(uid)/pendingInvitations/\(self.filteredUsernames[button.tag].id)": self.filteredUsernames[button.tag].username,
			"\(self.filteredUsernames[button.tag].id)/friendInvitations/\(uid)": username
			] as [String : Any]

		self.updateMultipleUserValues(updatedValues: addFriend)
		Analytics.logEvent("added_a_friend", parameters: Log.defaultInfo())
	}

}
