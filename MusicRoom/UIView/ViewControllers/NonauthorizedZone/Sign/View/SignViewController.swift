//
//  SignViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 11.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class SignViewController: UIViewController, SignViewProtocol, UITextFieldDelegate {

	struct AccountInfoModel {
		let email: String
		let password: String
		let passwordConfirm: String
	}

	private enum TextFieldTag: Int {
		case email = 0
		case password
		case passwordConfirm
	}

	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var passwordTextField = UITextField()
	private(set) lazy var passwordConfirmTextField = UITextField()
	private(set) lazy var createAccountButton = UIButton()

	private let locolizedStrings: LocalizedStrings.Sign.Type = LocalizedStrings.Sign.self

	private var presenter: SignPresenterProtocol?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = SignPresenter(view: self)
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
		let titleLabel = UILabel()
		titleLabel.text = locolizedStrings.title.localized
		titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
		navigationItem.titleView = titleLabel
	}

	// MARK: Setup

	private func setupUI() {
		setupPasswordConfirmTextField()
		setupPasswordTextField()
		setupEmailTextFied()
		setupCreateAccountButton()
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(passwordTextField.snp.top).offset(-32)
			make.width.equalTo(200)
		}
	}

	private func setupPasswordTextField() {
		view.addSubview(passwordTextField)

		passwordTextField.snp.makeConstraints { make in
			make.bottom.equalTo(passwordConfirmTextField.snp.top).offset(-32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupPasswordConfirmTextField() {
		view.addSubview(passwordConfirmTextField)

		passwordConfirmTextField.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
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
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}

	private func configureEmailTextFied() {
		emailTextFied.delegate = self
		emailTextFied.placeholder = locolizedStrings.emailPlaceholder.localized()
		emailTextFied.autocorrectionType = .no
		emailTextFied.autocapitalizationType = .none
		emailTextFied.borderStyle = .roundedRect
		emailTextFied.clearButtonMode = .whileEditing
		emailTextFied.tag = TextFieldTag.email.rawValue
	}

	private func configurePasswordTextField() {
		passwordTextField.delegate = self
		passwordTextField.placeholder = locolizedStrings.passwordPlaceholder.localized()
		passwordTextField.autocorrectionType = .no
		passwordTextField.autocapitalizationType = .none
		passwordTextField.borderStyle = .roundedRect
		passwordTextField.isSecureTextEntry = true
		passwordTextField.clearButtonMode = .whileEditing
		passwordTextField.tag = TextFieldTag.password.rawValue
	}

	private func configurePasswordConfirmTextField() {
		passwordConfirmTextField.delegate = self
		passwordConfirmTextField.placeholder =
			locolizedStrings.passwordConfirmationPlaceholder.localized()
		passwordConfirmTextField.autocorrectionType = .no
		passwordConfirmTextField.autocapitalizationType = .none
		passwordConfirmTextField.borderStyle = .roundedRect
		passwordConfirmTextField.isSecureTextEntry = true
		passwordConfirmTextField.clearButtonMode = .whileEditing
	}

	private func configureCreateAccountButton() {
		createAccountButton.backgroundColor = .systemPink
		createAccountButton.layer.cornerRadius = 32
		let buttonTitle = locolizedStrings.createAccountButtonTitle.localized()
		createAccountButton.setTitle(buttonTitle, for: .normal)
		createAccountButton.setTitleColor(.white, for: .normal)
		createAccountButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
		createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc func didTapCreateAccountButton() {
		var accountInfoModel: AccountInfoModel?

		if let email = emailTextFied.text,
			let password = passwordTextField.text,
			let passwordConfirm = passwordConfirmTextField.text,
			email.isEmpty == false,
			password.isEmpty == false,
			passwordConfirm.isEmpty == false
		{
			accountInfoModel = AccountInfoModel(email: email, password: password, passwordConfirm: passwordConfirm)
		}

		presenter?.createAccount(with: accountInfoModel)
	}

	// MARK: - SignViewProtocol

	func clearAllTextFieldsInput() {
		emailTextFied.text = ""
		emailTextFied.becomeFirstResponder()
		passwordTextField.text = ""
		passwordConfirmTextField.text = ""
	}

	// MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		textField.text = ""
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		switch textField.tag {
		case 0:
			guard let result = Validator.validate(email: textField.text) else {
				return true
			}
			if textField.text?.isEmpty == false {
				showBasicAlert(message: result)
				textField.text = ""
				return false
			}

		default:
			break
		}

		return true
	}
}
