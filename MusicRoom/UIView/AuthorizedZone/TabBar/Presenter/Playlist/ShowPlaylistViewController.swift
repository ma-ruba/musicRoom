//
//  ShowPlaylistViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 15.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

enum EditingState {
	case done
	case edit
}

final class ShowPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	let playlistId: String
	let playlistName: String
	let playlistType: PlaylistType
	var playlist: Playlist?
	var tracks: [PlaylistTrack] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	var editingState: EditingState = .done

	var playlistRef: DatabaseReference?
	var playlistHandle: UInt?
	var firebasePlaylistPath: String?

	private(set) lazy var tableView = UITableView()
	private(set) lazy var addFriendsButton = UIButton()
	private(set) lazy var infoLabel = UILabel()

	// MARK: Initializzation

	init(playlistId: String, playlistName: String, playlistType: PlaylistType) {
		self.playlistId = playlistId
		self.playlistName = playlistName
		self.playlistType = playlistType

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = playlistName
		let firstButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPlaylist))
		firstButton.isEnabled = true
		let secondButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
		navigationItem.rightBarButtonItems = [secondButton, firstButton]

		setupUI()
		configureUI()
		configureDatabase()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if let playlistHandle = self.playlistHandle {
			playlistRef?.removeObserver(withHandle: playlistHandle)
		}
	}

	// MARK: Private

	// MARK: Setup

	private func setupUI() {
		setupAddFriendsButton()
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
			make.top.equalTo(addFriendsButton.snp.bottom).offset(8)
		}
	}

	private func setupAddFriendsButton() {
		view.addSubview(addFriendsButton)

		addFriendsButton.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
			make.centerX.equalToSuperview()
			make.width.equalTo(100)
			make.height.equalTo(46)
		}
	}

	// MARK: Configure

	private func configureUI() {
		view.backgroundColor = .white


		configureTableView()
		configureAddFriendsButton()
		congigureInfoLabel()
	}

	private func configureAddFriendsButton() {
		if playlistType == .public {
			addFriendsButton.isEnabled = false
		}
		addFriendsButton.setTitle("Add friends", for: .normal)
		addFriendsButton.setTitleColor(.blue, for: .normal)
		addFriendsButton.setTitleColor(.gray, for: .disabled)
		addFriendsButton.addTarget(self, action: #selector(addFriends), for: .touchUpInside)
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 64
		tableView.registerReusable(cellClass: TrackTableViewCell.self)
	}

	private func congigureInfoLabel() {
		infoLabel.text = "You don't have any songs yet!"
	}

	// MARK: Other

	private func configureDatabase() {
		firebasePlaylistPath = "playlists/\(playlistType.self)/\(playlistId)"

		if let path = self.firebasePlaylistPath {
			playlistRef = Database.database().reference(withPath: path)
		}

		playlistHandle = playlistRef?.observe(.value, with: { [weak self] snapshot in
			guard let self = self else { return }
			let playlist = Playlist(snapshot: snapshot)
			self.playlist = playlist

			self.tracks = playlist.sortedTracks()
			if self.tracks.count == 0 {
				self.navigationItem.rightBarButtonItems?[safe: 1]?.isEnabled = false
				self.tableView.isHidden = true
				self.infoLabel.isHidden = false
			} else {
				self.navigationItem.rightBarButtonItems?[safe: 1]?.isEnabled = true
				self.tableView.isHidden = false
				self.infoLabel.isHidden = true
			}
		})
	}

	// MARK: - Actions

	@objc private func goBack() {
		dismiss(animated: true, completion: nil)
	}

	@objc private func addFriends() {
		let viewController = AddFriendsTableViewController()
		viewController.firebasePath = firebasePlaylistPath
		viewController.from = "playlist"
		viewController.name = playlist?.name
		viewController.createdBy = playlist?.createdBy
		let navigationController = UINavigationController(rootViewController: viewController)
		self.present(navigationController, animated: true)
	}

	@objc private func addSong() {
		let viewController = SongSearchViewController()
		viewController.from = "playlist"
		viewController.firebasePath = firebasePlaylistPath
		let navigationController = UINavigationController(rootViewController: viewController)
		self.present(navigationController, animated: true)
	}

	@objc private func editPlaylist() {
		let secondButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
		if editingState == .edit {
			tableView.setEditing(false, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
			editingState = .done
		} else {
			tableView.setEditing(true, animated: true)
			let firstButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editPlaylist))
			navigationItem.rightBarButtonItems = [secondButton, firstButton]
			editingState = .edit
		}
	}


	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tracks.count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: TrackTableViewCell.self, for: indexPath)
		cell.track = tracks[indexPath.row]

		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let path = firebasePlaylistPath {
			DeezerSession.sharedInstance.setMusic(toPlaylist: path, startingAt: indexPath.row)
		}
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete, let ref = playlistRef {
			let trackId = self.tracks[indexPath.row].trackKey

			ref.child("/tracks/\(trackId)").removeValue() { error, _ in
				Log.event("deleted_track", parameters: [
					"playlist_id": self.playlistId ?? "undefined",
					"track_id": trackId,
				])
			}
		}
	}

	func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
		var orderNumber: Double

		if toIndexPath.row == tracks.count - 1 {
			orderNumber = round(tracks[toIndexPath.row].orderNumber + 1)
		} else if toIndexPath.row == 0 {
			orderNumber = round(tracks[toIndexPath.row].orderNumber - 1)
		} else {
			orderNumber = (tracks[toIndexPath.row - 1].orderNumber + tracks[toIndexPath.row].orderNumber) / 2
		}
		if let ref = playlistRef {
			let trackId = tracks[fromIndexPath.row].trackKey

			ref.child("tracks/\(trackId)/orderNumber").setValue(orderNumber) { error, _ in
				Log.event("set_track_order_number")
			}
		}
	}

}
