//
//  PlaylistTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 13.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class PlaylistTableViewController: UITableViewController, PlaylistViewProtocol {

	private enum Constants {
		static let footerHeight: CGFloat = 46
		static let headerHeight: CGFloat = 46
	}

	private var presenter: PlaylistPresenterProtocol?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = PlaylistPresenter(view: self)
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

	// MARK: - PlaylistViewProtocol

	func reloadTableView() {
		tableView.reloadData()
	}

	// MARK: - TableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfRows(in: section) ?? 1
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let playlistType = PlaylistType(rawValue: section)
		guard let numberOfRows = presenter?.numberOfRows(in: section), numberOfRows > 0 else { return nil }

		return playlistType?.name.capitalized
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

		guard let playlistModel = presenter?.playlist(for: indexPath) else {
			let typeName = presenter?.typeName(for: indexPath.row) ?? ""
			cell.textLabel?.text = LocalizedStrings.Playlist.emptyPlaylistTitle.localized(withArgs: typeName)
			return cell
		}

		cell.textLabel?.text = playlistModel.name
		return cell
	}

	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return Constants.footerHeight
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return Constants.headerHeight
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.openPlaylist(at: indexPath)
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		guard presenter?.playlist(for: indexPath) != nil else { return false }
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }

		presenter?.deletePlaylist(at: indexPath)
		tableView.setEditing(false, animated: true)
	}

	// MARK: - Private

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.Playlist.navigationTitle.localized
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylist))
		navigationItem.rightBarButtonItem?.tintColor = .systemPink
	}

	private func configureTableView() {
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: - Actions

	@objc func addPlaylist() {
		presenter?.addPlaylist()
	}
}
