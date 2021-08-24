//
//  AddPlaylistTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 12.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class AddPlaylistTableViewController: UITableViewController, AddPlaylistViewProtocol {

	private enum Constants {
		static let headerHeight: CGFloat = 46
	}

	private var presenter: AddPlaylistPresenterProtocol

	// MARK: Initialization

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = AddPlaylistPresenter(view: self)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		configureNavigationItem()
		configureTableView()
	}

	// MARK: Private

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.AddPlaylist.navigationTitle.localized
	}

	private func configureTableView() {
		tableView.registerReusable(cellClass: TextFieldTableViewCell.self)
		tableView.registerReusable(cellClass: SwitchTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: - TableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return presenter.numberOfSections
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.numberOfRows(in: section)
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = presenter.item(for: indexPath)

		switch item {
		case .name:
			return tableView.dequeueReusableCell(withClass: TextFieldTableViewCell.self, for: indexPath)

		case .type:
			return tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)

		case .button:
			let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
			cell.textLabel?.text = LocalizedStrings.AddPlaylist.buttonTitle.localized
			cell.textLabel?.font = .systemFont(ofSize: 18)
			cell.textLabel?.textColor = .systemPink
			cell.textLabel?.textAlignment = .center

			return cell

		case .unnown:
			return UITableViewCell()
		}
	}

	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return Constants.headerHeight
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return EmptyView()
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = presenter.item(for: indexPath)

		switch item {
		case .button:
			guard let cell = tableView.cellForRow(at: IndexPath(row: item.rawValue, section: presenter.numberOfSections - 1)) as? TextFieldTableViewCell,
				cell.textField.text?.isEmpty == false
			else {
				return showBasicAlert(message: LocalizedStrings.AddPlaylist.noNameError.localized)
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
