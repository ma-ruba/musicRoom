//
//  S.swift
//  MusicRoom
//
//  Created by 18588255 on 15.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class SongSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

	class TrackResults {
		var deezerTracks: DZRObjectList

		var tracks: [Track?]

		init(deezerTracks: DZRObjectList, tracks: [Track?]) {
			self.deezerTracks = deezerTracks
			self.tracks = tracks
		}
	}

	private(set) lazy var tableView = UITableView()
	private(set) lazy var searchController = UISearchController(searchResultsController: nil)

	var currentSearch = ""
	var cachedResults: [String: TrackResults] = [:]
	var firebasePath: String?
	var from: String?

	var playlistRef: DatabaseReference?
	var playlistHandle: UInt?
	var latestPlaylist: Playlist?

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

		navigationItem.title = "Add a new track!"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))

		setupUI()
		configureUI()

		if let path = firebasePath {
			playlistRef = Database.database().reference(withPath: path)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		configureDatabase()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if let playlistHandle = playlistHandle {
			playlistRef?.removeObserver(withHandle: playlistHandle)
		}
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}


	// MARK: Configure

	private func configureUI() {
		configureTableView()
		configureSearchController()
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 64
		tableView.registerReusable(cellClass: TrackTableViewCell.self)
		tableView.tableHeaderView = searchController.searchBar
	}

	private func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
	}

	// MARK: Other

	private func configureDatabase() {

		playlistHandle = playlistRef?.observe(.value, with: { snapshot in
			self.latestPlaylist = Playlist(snapshot: snapshot)
		})
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cachedResults[currentSearch]?.tracks.count ?? 0
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return cachedResults[currentSearch] != nil ? 1 : 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: TrackTableViewCell.self, for: indexPath)

		if let trackResults = cachedResults[currentSearch] {
			if let track = trackResults.tracks[indexPath.row] {
				cell.track = track
			} else {
				cell.track = nil

				trackResults.deezerTracks.object(at: UInt(indexPath.row), with: DZRRequestManager.default(), callback: { (deezerTrack, getTrackError) in
					if getTrackError == nil, let deezerTrack = deezerTrack as? DZRTrack {
						deezerTrack.playableInfos(with: DZRRequestManager.default(), callback: { (songInfo, error) in
							if let name = songInfo?["DZRPlayableObjectInfoName"] as? String,
								let creator = songInfo?["DZRPlayableObjectInfoCreator"] as? String,
								let duration = songInfo?["DZRPlayableObjectInfoDuration"] as? Int {
								trackResults.tracks[indexPath.row] = Track(deezerId: deezerTrack.identifier(), name: name, creator: creator, duration: duration)

								self.tableView.reloadRows(at: [indexPath], with: .fade)
							}
						})
					} else {
						print("Error grabbing DZRTrack object at index", indexPath.row)
						print("Error:", getTrackError as Any)
					}
				})
			}
		}

		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let track = cachedResults[currentSearch]?.tracks[indexPath.row], let path = firebasePath {
			let playlistRef = Database.database().reference(withPath: path + "/tracks")
			let newSongRef = playlistRef.childByAutoId()

			var trackDict = track.toDict()
			if from == "playlist" {
				if let highestOrderNumber = latestPlaylist?.sortedTracks().last?.orderNumber {
					trackDict["orderNumber"] = highestOrderNumber + 1
				} else {
					trackDict["orderNumber"] = 0
				}
			}

			newSongRef.setValue(trackDict) { error, _ in
				guard error == nil else { return }

				Analytics.logEvent("song_added", parameters: Log.defaultInfo())
			}

			dismiss(animated: true, completion: nil)
		}
	}

	// MARK: - Actions

	@objc private func close() {
		dismiss(animated: true, completion: nil)
	}

	// MARK: - UISearchResultsUpdating

	public func updateSearchResults(for searchController: UISearchController) {
		if let searchText = searchController.searchBar.text {
			filterContentForSearchText(searchText: searchText)
		}
	}

	func filterContentForSearchText(searchText: String) {
		if cachedResults[searchText] == nil {
			if searchText != "" {

				DZRObject.search(for: DZRSearchType.track, withQuery: searchText, requestManager: DZRRequestManager.default(), callback: { (_ results: DZRObjectList?, _ error: Error?) -> Void in
					guard let results = results, error == nil else { return }

					let tracks = [Track?](repeating: nil, count: Int(results.count()))
					self.cachedResults[searchText] = TrackResults(deezerTracks: results, tracks: tracks)

					if let latestSearch = self.searchController.searchBar.text {
						self.currentSearch = latestSearch
					}

					self.tableView.reloadData()
				})
			}
		} else {
			currentSearch = searchText
			tableView.reloadData()
		}
	}
}
