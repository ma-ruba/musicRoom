//
//  ShowPlaylistViewController.swift
//  MusicRoom
//
//  Created by Mariia on 15.12.2020.
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

	private lazy var tableView = UITableView()
	private lazy var infoLabel = UILabel()

	// MARK: Initializzation

	init(with inputModel: Playlist) {
		super.init(nibName: nil, bundle: nil)

		presenter = ShowPlaylistPresenter(view: self, inputModel: inputModel)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

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
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(GlobalConstants.musicBarHeight)
			make.leading.trailing.equalToSuperview()
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
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = EmptyView()
		tableView.registerNibReusable(cellClass: LabelsTableViewCell.self)
	}

	private func congigureInfoLabel() {
		infoLabel.text = LocalizedStrings.ShowPlaylist.emptyList.localized
		infoLabel.font = .systemFont(ofSize: 24)
	}

	private func configureAppearance() {
		configureNavigationItem()
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

	func configureNavigationButton() {
		let secondButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
		secondButton.tintColor = .systemPink

		switch editingState {
		case .edit:
			tableView.setEditing(false, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
			firstButton.tintColor = .systemPink
			if presenter?.tracks.isEmpty == true { firstButton.isEnabled = false}

		case .done:
			tableView.setEditing(true, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
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
		let cell = tableView.dequeueReusableCell(withClass: LabelsTableViewCell.self, for: indexPath)
		guard let track = presenter?.tracks[indexPath.row] else { return cell }
		cell.configure(
			with: LabelsTableViewCellModel(
				mainLabelText: track.name,
				firstAdditionalInfoLabelText: track.creator,
				secondAdditionalInfoLabelText: String(format: "%01d:%02d", track.duration / 60, track.duration % 60)
			)
		)

		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.playTrack(at: indexPath.row)
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

	// MARK: - ShowPlaylistViewProtocol

	func reloadData() {
		tableView.isHidden = presenter?.tracks.isEmpty == true
		infoLabel.isHidden = presenter?.tracks.isEmpty == false
		tableView.reloadData()
		configureNavigationButton()
	}
}
