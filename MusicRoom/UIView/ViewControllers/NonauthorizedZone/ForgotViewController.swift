//
//  ForgotViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 19.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import Firebase

final class ForgotViewController: UIViewController {

	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var sendPasswordButton = UIButton()

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

		configureNavigationItem()
		setupUI()
		configureUI()
	}

	// MARK: Private

	private func configureNavigationItem() {
		navigationItem.title = "Reset your password"
	}

	// MARK: Setup

	private func setupUI() {
		setupEmailTextFied()
		setupSendPasswordButton()
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupSendPasswordButton() {
		view.addSubview(sendPasswordButton)

		sendPasswordButton.snp.makeConstraints { make in
			make.height.equalTo(64)
			make.centerX.equalToSuperview()
			make.left.right.equalToSuperview().inset(32)
			make.top.equalTo(emailTextFied.snp.bottom).offset(32)
		}
	}

	// MARK: Configure

	private func configureUI() {
		configureView()
		configureEmailTextFied()
		configuresSendPasswordButton()
	}

	private func configureView() {
		view.backgroundColor = .white
	}

	private func configureEmailTextFied() {
		emailTextFied.placeholder = "Email"
		emailTextFied.autocorrectionType = .no
		emailTextFied.autocapitalizationType = .none
		emailTextFied.borderStyle = .roundedRect
	}

	private func configuresSendPasswordButton() {
		sendPasswordButton.backgroundColor = .systemPink
		sendPasswordButton.layer.cornerRadius = 32
		sendPasswordButton.setTitle("Send", for: .normal)
		sendPasswordButton.setTitleColor(.white, for: .normal)
		sendPasswordButton.addTarget(self, action: #selector(didTapSendPasswordButton), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc func didTapBackButton() {
		dismiss(animated: true, completion: nil)
	}

	@objc func didTapSendPasswordButton() {
		guard let email = emailTextFied.text else {
			showBasicAlert(message: "Email field is mandatory")
			return
		}

		Auth.auth().sendPasswordReset(withEmail: email) { error in
			if error != nil {
				self.showBasicAlert(message: "There was a problem sending your password reset email.")
			} else {
				self.showBasicAlert(title: "Done!", message: "Go check your email to reset your password.")
			}
		}

		dismiss(animated: true, completion: nil)
	}
}
