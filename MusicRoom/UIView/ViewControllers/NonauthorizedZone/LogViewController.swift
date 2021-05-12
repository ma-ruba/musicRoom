//
//  LogViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 11.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import GoogleSignIn
//import FBSDKLoginKit
import Firebase

final class LogViewController: UIViewController, UITextFieldDelegate {

//	private(set) lazy var welcomeLabel = UILabel()
	private(set) lazy var stackView = UIStackView()
//	private(set) lazy var facebookButton = FBLoginButton()
	private(set) lazy var googleButton = GIDSignInButton()
	private(set) lazy var orLabel = UILabel()
	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var passwordTextField = UITextField()
	private(set) lazy var logInButton = UIButton()
	private(set) lazy var forgotButton = UIButton()


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

		// Google login stuff
		GIDSignIn.sharedInstance()?.presentingViewController = self

		configureNavigationItem()
		setupUI()
		confugureUI()
	}

	// MARK: Private

	private func configureNavigationItem() {
//		navigationController?.setNavigationBarHidden(false, animated: false)
//
//		navigationItem.leftBarButtonItem = UIBarButtonItem(
//			image: UIImage(name: .backArrow),
//			style: .plain,
//			target: self,
//			action: #selector(didTapBackButton)
//		)
//		navigationItem.leftBarButtonItem?.tintColor = .black
		navigationItem.title = "Welcome back!"
	}

	// MARK: Setup

	private func setupUI() {
//		setupWelcomeLabel()
		setupStackView()
//		setupFacebookButton()
		setupGoogleButton()
		setupOrLabel()
		setupEmailTextFied()
		setupPasswordTextField()
		setupLogInButton()
		setupForgotButton()
	}

//	private func setupWelcomeLabel() {
//		view.addSubview(welcomeLabel)
//
//		welcomeLabel.snp.makeConstraints { make in
//			make.centerX.equalToSuperview()
//			make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
//		}
//	}

	private func setupStackView() {
		view.addSubview(stackView)

		stackView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
//			make.right.left.equalToSuperview().inset(16)
			make.height.equalTo(48)
			make.width.equalTo(230)
			make.centerX.equalToSuperview()
		}
	}

//	private func setupFacebookButton() {
//		stackView.addArrangedSubview(facebookButton)
//	}

	private func setupGoogleButton() {
		stackView.addArrangedSubview(googleButton)
	}

	private func setupOrLabel() {
		view.addSubview(orLabel)

		orLabel.snp.makeConstraints { make in
			make.top.equalTo(stackView.snp.bottom).offset(16)
			make.centerX.equalToSuperview()
		}
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.top.equalTo(orLabel.snp.bottom).offset(32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)

		}
	}

	private func setupPasswordTextField() {
		view.addSubview(passwordTextField)

		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(emailTextFied.snp.bottom).offset(32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupLogInButton() {
		view.addSubview(logInButton)

		logInButton.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(64)
			make.height.equalTo(64)
			make.width.equalTo(120)
			make.centerX.equalToSuperview()
		}
	}

	private func setupForgotButton() {
		view.addSubview(forgotButton)

		forgotButton.snp.makeConstraints { make in
			make.top.equalTo(logInButton.snp.bottom).offset(32)
			make.centerX.equalToSuperview()
		}
	}

	// MARK: Configure

	private func confugureUI() {
		configureView()
//		configureWelcomeLabel()
		configureStackView()
//		configureFacebookButton()
		configureGoogleButton()
		configureOrLabel()
		configureEmailTextFied()
		configurePasswordTextField()
		configureLogInButton()
		configureForgotButton()
	}

	private func configureView() {
		view.backgroundColor = .white
	}

//	private func configureWelcomeLabel() {
//		let title = "Welcome back!"
//		welcomeLabel.font = .systemFont(ofSize: 20, weight: .semibold)
//		welcomeLabel.text = title
//		welcomeLabel.textColor = .black
//	}

	private func configureStackView() {
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.distribution = .fillEqually
	}

//	private func configureFacebookButton() {
////		facebookButton.addTarget(self, action: #selector(pressFacebookButton), for: .touchUpInside)
//		facebookButton.layer.cornerRadius = 8
//		facebookButton.delegate = self
//		facebookButton.permissions = ["email"]
//	}

	private func configureGoogleButton() {
		googleButton.layer.cornerRadius = 8
	}

	private func configureOrLabel() {
		let title = "or"
		orLabel.font = .systemFont(ofSize: 20, weight: .semibold)
		orLabel.textColor = .black
		orLabel.text = title
	}

	private func configureEmailTextFied() {
		emailTextFied.delegate = self
		emailTextFied.placeholder = "Email"
		emailTextFied.autocorrectionType = .no
		emailTextFied.autocapitalizationType = .none
		emailTextFied.borderStyle = .roundedRect
	}

	private func configurePasswordTextField() {
		passwordTextField.delegate = self
		passwordTextField.placeholder = "Password"
		passwordTextField.autocorrectionType = .no
		passwordTextField.autocapitalizationType = .none
		passwordTextField.borderStyle = .roundedRect
		passwordTextField.isSecureTextEntry = true
	}

	private func configureLogInButton() {
		let title = "Log in"
		logInButton.backgroundColor = .systemPink
		logInButton.layer.cornerRadius = 32
		logInButton.setTitle(title.uppercased(), for: .normal)
		logInButton.setTitleColor(.white, for: .normal)
		logInButton.addTarget(self, action: #selector(pressLogInButton), for: .touchUpInside)
	}

	private func configureForgotButton() {
		let title = "Forgot your password?"
		forgotButton.setTitle(title, for: .normal)
		forgotButton.addTarget(self, action: #selector(pressForgotButton), for: .touchUpInside)
		forgotButton.setTitleColor(.gray, for: .normal)
		forgotButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
	}

	// MARK: - Actions

	@objc private func pressForgotButton() {
		let signViewController = ForgotViewController()
		let navigationController = UINavigationController(rootViewController: signViewController)

		present(navigationController, animated: true)
	}

	@objc func pressLogInButton() {
		guard let email = emailTextFied.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
			return showBasicAlert(message: "All fields are mandatory")
		}

		Auth.auth().signIn(withEmail: email, password: password) { user, error in
			if error == nil {
				self.emailTextFied.text = nil
				self.passwordTextField.text = nil
				let viewController = TabBarViewController()
//				let viewController = MusicBarViewController()
				self.present(viewController, animated: true)
			} else if user == nil {
				self.showBasicAlert(title: "No account", message: "No record of this account was found")
			}
		}
	}

	@objc func didTapBackButton() {
		dismiss(animated: true, completion: nil)
	}
}
