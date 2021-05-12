//
//  PlaylistTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 13.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import Firebase

enum PlaylistType {
	case `private`
	case `public`
}

final class PlaylistTableViewController: UITableViewController {
	var privatePlaylist: [(uid: String, name: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	var publicPlaylist: [(uid: String, name: String)] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	var userRef: DatabaseReference?
	var userHandle: UInt?

	var publicPlaylistRef: DatabaseReference?
	var publicPlaylistHandle: UInt?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Playlist"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylist))

		if let userId = Auth.auth().currentUser?.uid {
			userRef = Database.database().reference(withPath: "users/" + userId)
		}

		publicPlaylistRef = Database.database().reference(withPath: "playlists/public")

		configureTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		configureDatabase()
	}

	override func viewDidDisappear(_ animated: Bool) {
		if let handle = userHandle {
			userRef?.removeObserver(withHandle: handle)
		}

		if let handle = publicPlaylistHandle {
			publicPlaylistRef?.removeObserver(withHandle: handle)
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return privatePlaylist.count == 0 ? 1 : privatePlaylist.count

		case 1:
			return publicPlaylist.count == 0 ? 1 : publicPlaylist.count

		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Private playlist"

		case 1:
			return "Public playlist"

		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
		var title = ""

		switch indexPath.section {
		case 0:
			if privatePlaylist.isEmpty { title += "No private playlist yet..." }
			title += privatePlaylist[safe: indexPath.row]?.name ?? ""

		case 1:
			if publicPlaylist.isEmpty { title += "No public playlist yet..." }
			title += publicPlaylist[safe: indexPath.row]?.name ?? ""

		default:
			break
		}

		cell.textLabel?.text = title
		return cell
	}

	

	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedPlaylist = playlistForIndexPath(indexPath: indexPath)
		let playlistType: PlaylistType = indexPath.section == 0 ? .private : .public
		guard let playlistId = selectedPlaylist?.uid, let playlistName = selectedPlaylist?.name else { return }

		let viewController = ShowPlaylistViewController(playlistId: playlistId, playlistName: playlistName, playlistType: playlistType)
		let navigationController = UINavigationController(rootViewController: viewController)
		present(navigationController, animated: true)
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if let playlists = playlistForSection(indexPath: indexPath) {
			return playlists.count > 0
		}

		return false
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			if indexPath.section == 0 {
				let privateRef = Database.database().reference(withPath: "playlists/private")
				privateRef.child(privatePlaylist[indexPath.row].uid).observeSingleEvent(of: .value, with: { snapshot in

					let playlist = Playlist(snapshot: snapshot)
					if playlist.createdBy != Auth.auth().currentUser?.uid {
						tableView.setEditing(false, animated: true)

						self.showBasicAlert(title: "You can't delete this playlist", message: "This playlist is not yours.")
					} else {
						let playlistId = self.privatePlaylist[indexPath.row].uid

						var userPlaylists: [AnyHashable: Any] = [
							"playlists/private/\(playlistId)": NSNull()
						]

						if let userIds = playlist.userIds {
							for user in userIds {
								userPlaylists["users/\(user.key)/playlists/\(playlistId)"] = NSNull()
							}
						}

						Database.database().reference().updateChildValues(userPlaylists) { error, _ in
							guard error == nil else { return }

							Analytics.logEvent("deleted_playlist", parameters: [
								"user_id": Auth.auth().currentUser?.uid as Any,
								"playlist_id": playlistId as Any,
							])
						}
					}
				})
			} else if indexPath.section == 1, let publicRef = publicPlaylistRef {
				publicRef.child(publicPlaylist[indexPath.row].uid).observeSingleEvent(of: .value, with: { snapshot in

					let playlist = Playlist(snapshot: snapshot)
					if playlist.createdBy != Auth.auth().currentUser?.uid {
						tableView.setEditing(false, animated: true)

						self.showBasicAlert(title: "You can't delete this playlist", message: "This playlist is not yours.")
					} else {
						let playlistId = self.publicPlaylist[indexPath.row].uid

						publicRef.child(playlistId).removeValue() { error, _ in
							guard error == nil else { return }

							Log.event("deleted_playlist", parameters: [
								"playlist_id": playlistId,
							])
						}
					}
				})

			}
		}
	}

	// MARK: - Private

	private func configureTableView() {
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	private func playlistForIndexPath(indexPath: IndexPath) -> (uid: String, name: String)? {
		switch indexPath.section {
		case 0:
			return privatePlaylist[safe: indexPath.row]

		case 1:
			return publicPlaylist[safe: indexPath.row]

		default:
			return nil
		}
	}

	private func playlistForSection(indexPath: IndexPath) -> [(uid: String, name: String)]? {
		switch indexPath.section {
		case 0:
			return privatePlaylist

		case 1:
			return publicPlaylist

		default:
			return nil
		}
	}

	private func configureDatabase() {

		publicPlaylistHandle = publicPlaylistRef?.observe(.value, with: { snapshot in
			var playlists = [(uid: String, name: String)]()
			for snap in snapshot.children {
				if let snap = snap as? DataSnapshot {
					let playlist = Playlist(snapshot: snap)
					if let ref = playlist.ref, let uid = ref.key {
						playlists.append((uid: uid, name: playlist.name))
					}
				}
			}
			self.publicPlaylist = playlists
		})

		userHandle = userRef?.observe(.value, with: { snapshot in
			var playlists = [(uid: String, name: String)]()
			let user = User(snapshot: snapshot)
			if let userPlaylists = user.playlists {
				for playlist in userPlaylists {
					playlists.append((uid: playlist.key, name: playlist.value))
				}
			}
			self.privatePlaylist = playlists
		})
	}

	// MARK: - Actions

	@objc func addPlaylist() {
		let viewController = AddPlaylistsTableViewController()
		let navigationController = UINavigationController(rootViewController: viewController)
		present(navigationController, animated: true)
	}
}
