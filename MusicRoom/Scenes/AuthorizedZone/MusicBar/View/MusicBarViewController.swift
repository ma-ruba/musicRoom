//
//  MusicBarViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 05.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class MusicBarViewController: UIViewController, MusicBarViewProtocol {

	private var presenter: MusicBarPresenterProtocol?

	private(set) lazy var label = UILabel()
	private(set) lazy var playView = UIView()
	private(set) lazy var playingButton = UIButton()

	public var embeddedViewController: UIViewController?

	private let text = LocalizedStrings.MusicBar.notActive.localized

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = MusicBarPresenter(view: self)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter?.setupPlayerDelegate()

		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		configureUI()
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		view.backgroundColor = .clear

		setupPlayView()
		setupLabel()
		setupButton()
	}

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
			make.edges.equalToSuperview()
		}
	}

	// MARK: Configure

	private func configureUI() {
		configurePlayView()
		configureButton()
		configureLabel()
	}

	private func configurePlayView() {
		playView.applyGradient(with: [.gray, .systemPink])
		playView.alpha = UIColor.Alpha.mediumFull.rawValue
	}

	private func configureButton() {
		playingButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
		changePlayPauseButtonState(to: presenter?.currentState ?? .disabled)
	}

	private func configureLabel() {
		label.text = text
		label.textColor = .black
	}

	// MARK: - PlayerDelegate

	func didStartPlaying(track: Track?) {
		guard let track = track else { return label.text = text }

		label.text = "\(track.name) by \(track.creator)"
	}

	func changePlayPauseButtonState(to newState: PlayingState) {
		presenter?.setNewState(newState)

		switch newState {
		case .play:
			playingButton.setImage(UIImage(name: .pause), for: .normal)
			playingButton.isEnabled = true
			playingButton.isHidden = false

		case .pause:
			playingButton.setImage(UIImage(name: .play), for: .normal)
			playingButton.isEnabled = true
			playingButton.isHidden = false

		case .disabled:
			playingButton.isHidden = true
			playingButton.isEnabled = false
		}
	}

	// MARK: Action

	@objc private func buttonPressed() {
		presenter?.buttonPressed()
	}
}
