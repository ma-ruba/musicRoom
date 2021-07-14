//
//  AddPlaylistsTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 12.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class AddPlaylistsTableViewController: UITableViewController {

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

		navigationItem.title = "Let's make a new playlist!"

		configureTableView()
	}

	// MARK: Private

	private func configureTableView() {
		tableView.registerReusable(cellClass: TextFieldTableViewCell.self)
		tableView.registerReusable(cellClass: SwitchTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)

		tableView.backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear

		return view
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear

		return view
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 46
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCell(withClass: TextFieldTableViewCell.self, for: indexPath)
			cell.layer.cornerRadius = 12
			cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
			return cell

		case 1:
			let cell = tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)
			return cell

		case 2:
			let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
			cell.textLabel?.text = "Create"
			cell.textLabel?.textColor = .blue
			cell.textLabel?.textAlignment = .center
			cell.layer.cornerRadius = 12
			cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
			return cell

		default:
			return UITableViewCell()
		}
	}

	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 2:
			guard let textCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell,
				let switchCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SwitchTableViewCell,
				let text = textCell.textField.text,
				text.isEmpty == false
			else {
				return showBasicAlert(message: "Name field can not be empty!")
			}

			guard let uid = Auth.auth().currentUser?.uid else { return }
			let playlist = Playlist(name: text, userId: uid)

			let playlistRef = Database.database().reference(withPath: "playlists/" + (switchCell.switchItem.isOn == true ? "public" : "private"))
			let newPlaylistRef = playlistRef.childByAutoId()
			guard let newPlaylistRefKey = newPlaylistRef.key else { return }
			if switchCell.switchItem.isOn {
				newPlaylistRef.setValue(playlist.toPublicObject()) { error, _ in
					guard error == nil else { return }

					Log.event("created_playlist", parameters: [
						"playlist_id": newPlaylistRefKey,
						"playlist_name": playlist.name,
						"public_or_private": "public",
					])
				}
			} else {
				let newPrivatePlaylistRef : [String:Any] = [
					"users/\(uid)/playlists/\(newPlaylistRef.key)": text,
					"playlists/private/\(newPlaylistRef.key)": playlist.toPrivateObject()
				]

				let ref = Database.database().reference()
				ref.updateChildValues(newPrivatePlaylistRef, withCompletionBlock: { (error, ref) -> Void in
					if error == nil {
						Log.event("created_playlist", parameters: [
							"playlist_id": newPlaylistRefKey,
							"playlist_name": playlist.name,
							"public_or_private": "private",
						])
					}
				})
			}
			dismiss(animated: true, completion: nil)

		default:
			break
		}
	}
}
