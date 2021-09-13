//
//  PlaylistViewController.swift
//  MusicRoom
//
//  Created by Mariia on 13.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class PlaylistViewController: UIViewController, PlaylistViewProtocol, UITableViewDelegate, UITableViewDataSource {

	private enum Constants {
		static let footerHeight: CGFloat = 46
		static let headerHeight: CGFloat = 46
	}

	private lazy var tableView = UITableView()

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

		setupUI()
		configureUI()
	}

	// MARK: - PlaylistViewProtocol

	func reloadTableView() {
		tableView.reloadData()
	}

	// MARK: - TableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfRows(in: section) ?? 1
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let playlistType = PlaylistType(rawValue: section)
		guard let numberOfRows = presenter?.numberOfRows(in: section), numberOfRows > 0 else { return nil }

		return playlistType?.name.capitalized
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

		guard let playlistModel = presenter?.playlist(for: indexPath) else { return cell }

		cell.textLabel?.text = playlistModel.name
		cell.selectionStyle = .none
		return cell
	}

	// MARK: - TableViewDelegate

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let numberOfRows = presenter?.numberOfRows(in: section), numberOfRows > 0 else { return 0 }
		
		return Constants.footerHeight
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let numberOfRows = presenter?.numberOfRows(in: section), numberOfRows > 0 else { return 0 }
		
		return Constants.headerHeight
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.openPlaylist(at: indexPath)
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		guard presenter?.playlist(for: indexPath) != nil else { return false }
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }

		presenter?.deletePlaylist(at: indexPath)
		tableView.setEditing(false, animated: true)
	}

	// MARK: - Private

	// MARK: Private

	private func setupUI() {
		setupTableView()
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(GlobalConstants.musicBarHeight)
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
		}
	}

	// MARK: Configure

	private func configureUI() {
		configureNavigationItem()
		configureTableView()
	}

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.Playlist.navigationTitle.localized
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaylist))
		navigationItem.rightBarButtonItem?.tintColor = .systemPink
	}

	private func configureTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: - Actions

	@objc func addPlaylist() {
		presenter?.addPlaylist()
	}
}
