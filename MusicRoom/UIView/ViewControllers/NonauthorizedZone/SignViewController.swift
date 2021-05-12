//
//  SignViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 11.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import Firebase

final class SignViewController: UIViewController, UITextFieldDelegate {

	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var passwordTextField = UITextField()
	private(set) lazy var passwordConfirmTextField = UITextField()
	private(set) lazy var createAccountButton = UIButton()

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
		confugureUI()
	}

	// MARK: Private

	private func configureNavigationItem() {
		navigationItem.title = "Hello! Sign up:"
	}

	// MARK: Setup

	private func setupUI() {
		setupEmailTextFied()
		setupPasswordTextField()
		setupPasswordConfirmTextField()
		setupCreateAccountButton()
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
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

	private func setupPasswordConfirmTextField() {
		view.addSubview(passwordConfirmTextField)

		passwordConfirmTextField.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupCreateAccountButton() {
		view.addSubview(createAccountButton)

		createAccountButton.snp.makeConstraints { make in
			make.height.equalTo(64)
			make.centerX.equalToSuperview()
			make.left.right.equalToSuperview().inset(32)
			make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(32)
		}
	}

	private func confugureUI() {
		configureView()
		configureEmailTextFied()
		configurePasswordTextField()
		configurePasswordConfirmTextField()
		configureCreateAccountButton()
	}

	private func configureView() {
		view.backgroundColor = .white
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

	private func configurePasswordConfirmTextField() {
		passwordConfirmTextField.delegate = self
		passwordConfirmTextField.placeholder = "Password confirmation"
		passwordConfirmTextField.autocorrectionType = .no
		passwordConfirmTextField.autocapitalizationType = .none
		passwordConfirmTextField.borderStyle = .roundedRect
		passwordConfirmTextField.isSecureTextEntry = true
	}

	private func configureCreateAccountButton() {
		createAccountButton.backgroundColor = .systemPink
		createAccountButton.layer.cornerRadius = 32
		createAccountButton.setTitle("Create Account", for: .normal)
		createAccountButton.setTitleColor(.white, for: .normal)
		createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
	}


	// MARK: - Actions

	@objc func didTapBackButton() {
		dismiss(animated: true, completion: nil)
	}

	@objc func didTapCreateAccountButton() {
		guard let email = emailTextFied.text,
			let password = passwordTextField.text,
			let passwordConfirm = passwordConfirmTextField.text
		else { return showBasicAlert(message: "All fields are mandatory.") }

		guard password == passwordConfirm else {
			return showBasicAlert(message: "Password and confirmed password must match.")
		}

		Auth.auth().createUser(withEmail: email, password: password) { user, error in
			if error != nil {
				print(error)
				self.showBasicAlert(message: error?.localizedDescription ?? "There was a problem sending your password reset email.")
				self.emailTextFied.text = nil
				self.passwordTextField.text = nil
				self.passwordConfirmTextField.text = nil
			} else {
				
			}
		}
	}

}
