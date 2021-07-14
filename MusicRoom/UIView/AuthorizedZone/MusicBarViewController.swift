//
//  MusicBarViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 05.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

class MusicBarViewController: UIViewController, PlayerDelegate {

	private(set) lazy var label = UILabel()
	private(set) lazy var playView = UIView()
	private(set) lazy var playingButton = UIButton()

	public var embeddedViewController: UIViewController?

	private let text = "Nothing playing... yet!"
	private var isPlaying: Bool?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		setupUI()
		configureUI()
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		DeezerSession.sharedInstance.setUp(playerDelegate: self)

		setupUI()
		configureUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		if DeezerSession.sharedInstance.deezerPlayer?.isPlaying() == true {
			self.changePlayPauseButtonState(to: true)
		} else if DeezerSession.sharedInstance.deezerPlayer?.isReady() == true {
			self.changePlayPauseButtonState(to: false)
		} else {
			self.changePlayPauseButtonState(to: nil)
		}
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		view.backgroundColor = .clear

		setupPlayView()
//		setupChildViewController()
		setupLabel()
		setupButton()
	}

//	private func setupChildViewController() {
//		let viewController = TabBarViewController()
//		embeddedViewController = viewController
//		addChild(viewController)
//
//		view.addSubview(viewController.view)
//		viewController.didMove(toParent: self)
//
//		viewController.view.snp.makeConstraints { make in
//			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
//			make.right.left.equalToSuperview()
//		}
//	}

	private func setupLabel() {
		playView.addSubview(label)

		label.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(16)
		}
	}

	private func setupButton() {
		playView.addSubview(playingButton)

		playingButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().inset(16)
			make.size.equalTo(36)
		}
	}

	private func setupPlayView() {
		view.addSubview(playView)

		playView.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.bottom.equalTo(view.safeAreaLayoutGuide)
//			make.height.equalTo(55)
		}
	}

	// MARK: Configure

	private func configureUI() {
		configurePlayView()
		configureButton()
		configureLabel()
	}

	private func configurePlayView() {
		playView.backgroundColor = .lightGray
	}

	private func configureButton() {
		playingButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
		playingButton.setImage(UIImage(name: .play), for: .normal)
	}

	private func configureLabel() {
		label.text = text
		label.textColor = .black
	}

	// MARK: - PlayerDelegate

	func didStartPlaying(track: Track?) {
		DispatchQueue.main.async {
			if let track = track {
				self.label.text = "\(track.name) by \(track.creator)"
			} else {
				self.label.text = self.text
			}
		}
	}

	func changePlayPauseButtonState(to newState: Bool?) {
		isPlaying = newState

		DispatchQueue.main.async {
			if newState == true {
				self.playingButton.setImage(UIImage(name: .pause), for: .normal)
				self.playingButton.isEnabled = true
			} else if newState == false {
				self.playingButton.setImage(UIImage(name: .play), for: .normal)
				self.playingButton.isEnabled = true
			} else {
				self.playingButton.setImage(UIImage(name: .play), for: .normal)
				self.playingButton.isEnabled = false
			}
		}
	}

	// MARK: Action

	@objc private func buttonPressed() {
		if self.isPlaying == false {
			DeezerSession.sharedInstance.controller?.play()
		} else {
			DeezerSession.sharedInstance.controller?.pause()
		}
	}
}
