//
//  StartViewController.swift
//  MusicRoom
//
//  Created by Mariia on 10.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import SnapKit

final class StartViewController: UIViewController, StartViewProtocol {

	private lazy var logoImageView = UIImageView()
	private lazy var logButton = UIButton()
	private lazy var signButton = UIButton()
	private lazy var welcomeLabel = UILabel()

	private var presenter: StartPresenterProtocol?

	private let locolizedStrings: LocalizedStrings.Start.Type = LocalizedStrings.Start.self

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

		presenter = StartPresenter(view: self)
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
			make.top.equalTo(view.safeAreaLayoutGuide).offset(1)
			make.centerX.equalToSuperview()
			make.size.equalTo(64)
		}
	}

	private func setupLogButton() {
		view.addSubview(logButton)

		logButton.snp.makeConstraints { make in
			make.height.equalTo(64)
			make.bottom.equalToSuperview().inset(64)
			make.leading.trailing.equalToSuperview().inset(32)
		}
	}

	private func setupSignButton() {
		view.addSubview(signButton)

		signButton.snp.makeConstraints { make in
			make.height.equalTo(logButton)
			make.bottom.equalTo(logButton.snp.top).inset(-8)
			make.leading.trailing.equalToSuperview().inset(32)
		}
	}

	private func setupWelcomeLabel() {
		view.addSubview(welcomeLabel)

		welcomeLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.leading.trailing.equalToSuperview().inset(16)
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
		let title = locolizedStrings.logIn.localized
		logButton.setTitle(title.uppercased(), for: .normal)
		logButton.setTitleColor(.white, for: .normal)
		logButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		logButton.addTarget(self, action: #selector(pressLogButton), for: .touchUpInside)
	}

	private func configureSignButton() {
		let title = locolizedStrings.signUp.localized
		signButton.setTitle(title.uppercased(), for: .normal)
		signButton.setTitleColor(.black, for: .normal)
		signButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		signButton.addTarget(self, action: #selector(pressSignButton), for: .touchUpInside)
		signButton.backgroundColor = .white
		signButton.layer.cornerRadius = 32
	}

	private func configureWelcomeLabel() {
		let title = locolizedStrings.welcomeWord.localized
		welcomeLabel.font = .systemFont(ofSize: 56, weight: .bold)
		welcomeLabel.text = title
		welcomeLabel.textColor = .white
		welcomeLabel.numberOfLines = 0
		welcomeLabel.textAlignment = .center
	}

	// MARK: - Actions

	@objc func pressLogButton() {
		presenter?.logIn()
	}

	@objc private func pressSignButton() {
		presenter?.signUp()
	}
}

