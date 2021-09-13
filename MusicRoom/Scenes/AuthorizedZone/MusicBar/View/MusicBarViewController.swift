//
//  MusicBarViewController.swift
//  MusicRoom
//
//  Created by Mariia on 05.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class MusicBarViewController: UIViewController, MusicBarViewProtocol {

	private var presenter: MusicBarPresenterProtocol?

	private lazy var label = UILabel()
	private lazy var playView = UIView()
	private lazy var playingButton = UIButton()

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		print("Hello")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		configureUI()
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupPlayView()
		setupLabel()
		setupButton()
	}

	private func setupLabel() {
		playView.addSubview(label)

		label.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
		}
	}

	private func setupButton() {
		playView.addSubview(playingButton)

		playingButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().inset(16)
			make.size.equalTo(55)
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
		playingButton.tintColor = .black
		configurePlayPauseButtonState()
	}

	private func configureLabel() {
		label.text = presenter?.playingInfo
		label.textColor = .black
	}

	private func updatePlayingInfo() {
		label.text = presenter?.playingInfo
	}

	private func configurePlayPauseButtonState() {
		let state = presenter?.currentState ?? .disabled

		switch state {
		case .isPlaying:
			playingButton.setImage(UIImage(systemName: "pause"), for: .normal)
			playingButton.isEnabled = true
			playingButton.isHidden = false

		case .isSuspended:
			playingButton.setImage(UIImage(systemName: "play"), for: .normal)
			playingButton.isEnabled = true
			playingButton.isHidden = false

		case .disabled:
			playingButton.isHidden = true
			playingButton.isEnabled = false
		}
	}

	// MARK: - Action

	@objc private func buttonPressed() {
		presenter?.buttonPressed()
	}

	// MARK: - MusicBarViewProtocol

	func updateAppearance() {
		updatePlayingInfo()
		configurePlayPauseButtonState()
	}
}
