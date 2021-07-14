//
//  ShowEventViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit


final class ShowEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private(set) lazy var tableView = UITableView()
	private(set) lazy var leftButton = UIButton()
	private(set) lazy var rightButton = UIButton()
	private(set) lazy var stackView = UIStackView()
	private(set) lazy var label = UILabel()

	var eventUid: String
	var eventName: String
	var eventType: EventType
	var firebasePath: String?

	var eventRef: DatabaseReference?
	var eventHandle: UInt?

	var tracks: [EventTrack]? {
		didSet {
			configureElementsVisuability()
			tableView.reloadData()
		}
	}
	var event: Event?

	// MARK: Initialization

	init(eventUid: String, eventName: String, eventType: EventType) {
		self.eventUid = eventUid
		self.eventName = eventName
		self.eventType = eventType

//		event = Event(name: eventName, createdBy: <#T##String#>)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle


	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		configureUI()

		let publicOrPrivate = (eventType == .public ? "public" : "private")
		let path = "events/\(publicOrPrivate)/\(eventUid)"

		firebasePath = path
		eventRef = Database.database().reference(withPath: path)
	}

	override func viewWillAppear(_ animated: Bool) {
		configureDatabase()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if let handle = eventHandle {
			eventRef?.removeObserver(withHandle: handle)
		}
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
		setupStackview()
		setupLeftButton()
		setupRightButton()
		setupLabel()
	}

	private func setupStackview() {
		view.addSubview(stackView)

		stackView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(64)
			make.bottom.equalTo(tableView.snp.top)
		}
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.left.right.equalToSuperview()
		}
	}

	private func setupLabel() {
		view.addSubview(label)

		label.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	private func setupRightButton() {
		stackView.addArrangedSubview(rightButton)

	}

	private func setupLeftButton() {
		stackView.addArrangedSubview(leftButton)
	}

	// MARK: Configure

	private func configureUI() {
		view.backgroundColor = .white
		navigationItem.title = eventName
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))

		configureTableView()
		configureStackView()
		configureLeftButton()
		configureRightButton()
		configureLabel()
		configureElementsVisuability()
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 90
		tableView.registerReusable(cellClass: TrackVoteTableViewCell.self)
	}

	private func configureLabel() {
		label.textAlignment = .center
		label.text = "You have no tracks yet!"
		label.textColor = .black
	}

	private func configureStackView() {
		stackView.axis = .horizontal
		stackView.spacing = 16
		stackView.distribution = .fillProportionally
		stackView.alignment = .center
	}

	private func configureLeftButton() {
		leftButton.setTitle("Start", for: .normal)
		leftButton.addTarget(self, action: #selector(start), for: .touchUpInside)
		leftButton.setTitleColor(.blue, for: .normal)
		leftButton.setTitleColor(.gray, for: .disabled)
	}

	private func configureRightButton() {
		if eventType == .public {
			rightButton.setTitle("Music Controll", for: .normal)
			//????
//			rightButton.isEnabled = false
		} else {
			rightButton.setTitle("Add Friends", for: .normal)
		}

		rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
		rightButton.setTitleColor(.blue, for: .normal)
	}

	private func configureElementsVisuability() {
		if tracks?.isEmpty == false {
			tableView.isHidden = false
			label.isHidden = true
			leftButton.isEnabled = true
		} else {
			tableView.isHidden = true
			label.isHidden = false
			leftButton.isEnabled = false
		}
	}

	// MARK: Other

	private func configureDatabase() {
		eventHandle = eventRef?.observe(.value, with: { snapshot in
			self.event = Event(snapshot: snapshot)
			self.tracks = self.event?.sortedTracks()

			guard let userId = Auth.auth().currentUser?.uid else { return }

			if self.event?.createdBy == userId {
				if self.event?.playingOnDeviceId != nil {
					self.leftButton.isEnabled = true

					if self.event?.playingOnDeviceId == DeezerSession.sharedInstance.deviceId {
						self.leftButton.setTitle("Stop", for: .normal)
					} else {
						if self.event?.isCurrentlyPlaying == true {
							self.leftButton.setTitle("Pause", for: .normal)
						} else {
							self.leftButton.setTitle("Play", for: .normal)
						}
					}
				} else {
					self.leftButton.setTitle("Start", for: .normal)
				}
			} else {
				if self.event?.playingOnDeviceId != nil, self.event?.userIds?[userId] == true {
					if self.event?.isCurrentlyPlaying == true {
						self.leftButton.setTitle("Pause", for: .normal)
						self.leftButton.isEnabled = true
					} else if self.event?.isCurrentlyPlaying == false {
						self.leftButton.setTitle("Play", for: .normal)
						self.leftButton.isEnabled = true
					} else {
						self.leftButton.setTitle("Play", for: .normal)
						self.leftButton.isEnabled = false
					}
				} else {
					self.leftButton.isEnabled = false
				}
			}

			if self.event?.createdBy == userId || self.event?.userIds?[userId] == true {
				self.rightButton.isEnabled = true
			} else {
				self.rightButton.isEnabled = false
			}
		})
	}

	// MARK: - Actions

	@objc private func start() {
		guard let path = firebasePath, let buttonText = leftButton.titleLabel?.text else { return }

		let eventDeviceRef = Database.database().reference(withPath: path + "/playingOnDeviceId")
		let eventCurrentlyPlayingRef = Database.database().reference(withPath: path + "/isCurrentlyPlaying")

		switch buttonText {
		case "Start":
			if let deviceId = DeezerSession.sharedInstance.deviceId {
				eventDeviceRef.setValue(deviceId, withCompletionBlock: { (error, reference) in
					if error == nil {
						eventDeviceRef.onDisconnectRemoveValue()
						eventCurrentlyPlayingRef.onDisconnectRemoveValue()
						DeezerSession.sharedInstance.setMusic(toEvent: path)
					}
				})
		}

		case "Stop":
			DeezerSession.sharedInstance.clearMusic()
			eventDeviceRef.removeValue()

			eventDeviceRef.cancelDisconnectOperations()
			eventCurrentlyPlayingRef.cancelDisconnectOperations()

		case "Play":
			eventCurrentlyPlayingRef.setValue(true)

		case "Pause":
			eventCurrentlyPlayingRef.setValue(false)

		default:
			break
		}
	}

	@objc private func rightButtonPressed() {
		if rightButton.title(for: .normal) == "Add Friends" {
			let viewController = AddFriendsTableViewController()
			viewController.firebasePath = firebasePath
			viewController.from = "event"
			viewController.name = event?.name
			viewController.createdBy = event?.createdBy
			let navigationController = UINavigationController(rootViewController: viewController)
			present(navigationController, animated: true)
		} else {

		}
	}

	@objc private func goBack() {
		dismiss(animated: true, completion: nil)
	}

	@objc private func addSong() {
		let viewController = SongSearchViewController()
		viewController.firebasePath = firebasePath
		let navigationController = UINavigationController(rootViewController: viewController)
		present(navigationController, animated: true)
	}

	@objc func upVote(sender: UIButton) {
		guard let track = tracks?[sender.tag],
			let currentUser = Auth.auth().currentUser?.uid,
			let ref = self.eventRef?.child("tracks/" + track.trackKey) else {
				return
		}

		ref.runTransactionBlock({ (currentData: MutableData) in

			guard let currentValue = currentData.value as? [String: AnyObject] else {
				return TransactionResult.abort()
			}

			let currentTrack = EventTrack(dict: currentValue, trackKey: track.trackKey)

			let userVote = currentTrack.voters?[currentUser]

			if userVote == false {
				currentTrack.vote += 2
				currentTrack.voters?[currentUser] = true
			} else if userVote == nil {
				currentTrack.vote += 1
				currentTrack.voters?[currentUser] = true
			} else if userVote == true {
				currentTrack.vote -= 1
				currentTrack.voters?[currentUser] = nil
			}

			currentData.value = currentTrack.toDict()
			return TransactionResult.success(withValue: currentData)
		}, andCompletionBlock: {
			(error, committed, snapshot) in
			if error != nil {
				print(error?.localizedDescription ?? "No description of the error")
			}
		})

	}

	@objc func downVote(sender: UIButton) {
		guard let track = tracks?[sender.tag],
			let currentUser = Auth.auth().currentUser?.uid,
			let ref = self.eventRef?.child("tracks/" + track.trackKey) else {
				return
		}

		ref.runTransactionBlock({ (currentData: MutableData) in

			guard let currentValue = currentData.value as? [String: AnyObject] else {
				return TransactionResult.abort()
			}

			let currentTrack = EventTrack(dict: currentValue, trackKey: track.trackKey)

			let userVote = currentTrack.voters?[currentUser]

			if userVote == true {
				currentTrack.vote -= 2
				currentTrack.voters?[currentUser] = false
			} else if userVote == nil {
				currentTrack.vote -= 1
				currentTrack.voters?[currentUser] = false
			} else if userVote == false {
				currentTrack.vote += 1
				currentTrack.voters?[currentUser] = nil
			}

			currentData.value = currentTrack.toDict()
			return TransactionResult.success(withValue: currentData)
		}, andCompletionBlock: {
			(error, committed, snapshot) in
			if error != nil {
				print(error?.localizedDescription ?? "No description of the error")
			}
		})
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tracks?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: TrackVoteTableViewCell.self, for: indexPath)

		if let tracks = tracks, tracks.count > 0, let currentUser = Auth.auth().currentUser?.uid {
			cell.titleLabel.text = tracks[indexPath.row].name
			cell.authorLabel.text = tracks[indexPath.row].creator
			cell.scoreLabel.text = String(describing: tracks[indexPath.row].vote)

			if tracks[indexPath.row].voters?[currentUser] == true {
				cell.leftButton.setTitle("✅", for: .normal)
				cell.rightButton.setTitle("👎", for: .normal)
			} else if tracks[indexPath.row].voters?[currentUser] == false {
				cell.leftButton.setTitle("👍", for: .normal)
				cell.rightButton.setTitle("❌", for: .normal)
			} else {
				cell.leftButton.setTitle("👍", for: .normal)
				cell.rightButton.setTitle("👎", for: .normal)
			}

			cell.leftButton.tag = indexPath.row
			cell.rightButton.tag = indexPath.row
			cell.leftButton.addTarget(self, action: #selector(upVote), for: .touchUpInside)
			cell.rightButton.addTarget(self, action: #selector(downVote), for: .touchUpInside)
		}

		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	// MARK: - UITableViewDelegate


}
