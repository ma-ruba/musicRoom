//
//  ShowPlaylistViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 15.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class ShowPlaylistViewController: UIViewController, ShowPlaylistViewProtocol, UITableViewDelegate, UITableViewDataSource {

	/// States of rightBarItem of navigationItem.
	private enum EditingState {

		/// State in which navigationItem has done button.
		case done

		/// State in which navigationItem has edit button.
		case edit

		/// Method returns the opposite value.
		mutating func toggle() {
			self = (self == .done ? .edit : .done)
		}
	}

	private var presenter: ShowPlaylistPresenterProtocol?
	private var editingState: EditingState = .edit

	private(set) lazy var tableView = UITableView()
	private(set) lazy var infoLabel = UILabel()

	// MARK: Initializzation

	init(with inputModel: PlaylistItem) {
		super.init(nibName: nil, bundle: nil)

		presenter = ShowPlaylistPresenter(view: self)
		presenter?.configureModel(with: inputModel)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureNavigationItem()
		setupUI()
		configureUI()
		configureAppearance()
	}

	// MARK: Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
		setupInfoLabel()
	}

	private func setupInfoLabel() {
		view.addSubview(infoLabel)

		infoLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.left.right.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
		}
	}

	// MARK: Configure

	private func configureNavigationItem() {
		navigationItem.title = presenter?.playlistName
		navigationController?.navigationBar.tintColor = .gray
		configureNavigationButton()
	}

	private func configureUI() {
		view.backgroundColor = .white

		configureTableView()
		congigureInfoLabel()
	}

	private func configureTableView() {
		infoLabel.isHidden = presenter?.tracks.isEmpty == true
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 64
		tableView.registerReusable(cellClass: TrackTableViewCell.self)
	}

	private func congigureInfoLabel() {
		infoLabel.isHidden = presenter?.tracks.isEmpty == false
		infoLabel.text = LocalizedStrings.ShowPlaylist.emptyList.localized
		infoLabel.font = .systemFont(ofSize: 24)
	}

	private func configureAppearance() {
		if presenter?.tracks.isEmpty == false {
			navigationItem.rightBarButtonItems?[safe: 1]?.isEnabled = true
			tableView.isHidden = false
			infoLabel.isHidden = true
		} else {
			navigationItem.rightBarButtonItems?[safe: 1]?.isEnabled = false
			tableView.isHidden = true
			infoLabel.isHidden = false
		}
	}

	private func configureNavigationButton() {
		let secondButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
		secondButton.tintColor = .systemPink

		switch editingState {
		case .edit:
			tableView.setEditing(false, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
			editingState = .done
			firstButton.tintColor = .gray

		case .done:
			tableView.setEditing(true, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
			editingState = .edit
			firstButton.tintColor = .gray
		}
	}

	// MARK: - Actions

	@objc private func addSong() {
		presenter?.addSong()
	}

	@objc private func editPlaylist() {
		editingState.toggle()
		configureNavigationButton()
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.tracks.count ?? 0
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: TrackTableViewCell.self, for: indexPath)
		cell.track = presenter?.tracks[indexPath.row]

		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if let path = firebasePlaylistPath {
//			DeezerSession.sharedInstance.setMusic(toPlaylist: path, startingAt: indexPath.row)
//		}
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }

		presenter?.deleteTrack(at: indexPath.row)
	}

	func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
		guard let endIndex = presenter?.tracks.endIndex, toIndexPath.row < endIndex else { return }

		presenter?.reorderTrack(from: fromIndexPath.row, to: toIndexPath.row)
	}

}
