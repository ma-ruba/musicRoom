//
//  StartViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 10.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import SnapKit

final class StartViewController: UIViewController {

	private(set) lazy var logoImageView = UIImageView()
	private(set) lazy var logButton = UIButton()
	private(set) lazy var signButton = UIButton()
	private(set) lazy var welcomeLabel = UILabel()

	// MARK: Initializzation

	init() {
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
	}

	// MARK: Private

	//MARK: Setup

	private func setupUI() {
		setupLogoImageView()
		setupLogButton()
		setupSignButton()
		setupWelcomeLabel()
	}

	private func setupLogoImageView() {
		view.addSubview(logoImageView)
		logoImageView.contentMode = .scaleAspectFit

		logoImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(9)
			make.centerX.equalToSuperview()
		}
	}

	private func setupLogButton() {
		view.addSubview(logButton)

		logButton.snp.makeConstraints { make in
			make.height.equalTo(64)
			make.bottom.equalToSuperview().inset(64)
			make.left.right.equalToSuperview().inset(32)
		}
	}

	private func setupSignButton() {
		view.addSubview(signButton)

		signButton.snp.makeConstraints { make in
			make.height.equalTo(logButton)
			make.bottom.equalTo(logButton.snp.top).inset(-8)
			make.left.right.equalToSuperview().inset(32)
		}
	}

	private func setupWelcomeLabel() {
		view.addSubview(welcomeLabel)

		welcomeLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.left.right.equalToSuperview().inset(16)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureView()
		configureLogoImageView()
		configureLogButton()
		configureSignButton()
		configureWelcomeLabel()
	}

	private func configureView() {
		view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
	}

	private func configureLogoImageView() {
		logoImageView.image = UIImage(name: .logo)
	}

	private func configureLogButton() {
		let title = "Log in"
		logButton.setTitle(title.uppercased(), for: .normal)
		logButton.setTitleColor(.white, for: .normal)
		logButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		logButton.addTarget(self, action: #selector(pressLogButton), for: .touchUpInside)
	}

	private func configureSignButton() {
		let title = "Sign up"
		signButton.setTitle(title.uppercased(), for: .normal)
		signButton.setTitleColor(.black, for: .normal)
		signButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		signButton.addTarget(self, action: #selector(pressSignButton), for: .touchUpInside)
		signButton.backgroundColor = .white
		signButton.layer.cornerRadius = 32
	}

	private func configureWelcomeLabel() {
		let title = "Find your sound"
		welcomeLabel.font = .systemFont(ofSize: 56, weight: .bold)
		welcomeLabel.text = title
		welcomeLabel.textColor = .white
		welcomeLabel.numberOfLines = 0
		welcomeLabel.textAlignment = .center
	}

	// MARK: - Actions

	@objc func pressLogButton() {
		let logViewController = LogViewController()
		let navigationController = UINavigationController(rootViewController: logViewController)

		present(navigationController, animated: true)
	}

	@objc private func pressSignButton() {
		let signViewController = SignViewController()
		let navigationController = UINavigationController(rootViewController: signViewController)

		present(navigationController, animated: true)
	}
}

