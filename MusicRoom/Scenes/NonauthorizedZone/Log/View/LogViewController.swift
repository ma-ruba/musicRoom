//
//  LogViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 11.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn

final class LogViewController:
	UIViewController,
	LogViewProtocol,
	UITextFieldDelegate
{

	struct AccountInfoModel {
		let email: String
		let password: String
	}

	private enum TextFieldTag: Int {
		case email = 0
		case password
	}

//	private(set) lazy var scrollView = UIScrollView()
	private(set) lazy var stackView = UIStackView()
	private(set) lazy var googleButton = GIDSignInButton()
	private(set) lazy var orLabel = UILabel()
	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var passwordTextField = UITextField()
	private(set) lazy var logInButton = UIButton()
	private(set) lazy var forgotButton = UIButton()

//	private(set) var forgotButtonBottomConstraint: SnapKit.Constraint?

	private let locolizedStrings: LocalizedStrings.Log.Type = LocalizedStrings.Log.self

	private var presenter: LogPresenter?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = LogPresenter(view: self)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter?.makeSetups()
		configureNavigationItem()
		setupUI()
		confugureUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setNavigationBarHidden(false, animated: true)
//		registerForKeyboardNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.setNavigationBarHidden(true, animated: true)
	}

//	override func keyboardWillChangeFrame(from beginFrame: CGRect, to endFrame: CGRect) {
//		let screenHeight: CGFloat = UIScreen.main.bounds.size.height
//		let keyboardY: CGFloat = endFrame.origin.y
//		let bottomInset: CGFloat = view.safeAreaInsets.bottom
//		let endHeight: CGFloat = max(screenHeight - keyboardY - bottomInset, 0)
//		forgotButtonBottomConstraint?.update(offset: -endHeight)
//		view.layoutIfNeeded()
//	}

	// MARK: Private

	private func configureNavigationItem() {
		let titleLabel = UILabel()
		titleLabel.text = locolizedStrings.title.localized
		titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
		navigationItem.titleView = titleLabel
	}

	// MARK: Setup

	private func setupUI() {
//		setupScrollView()
		setupStackView()
		setupGoogleButton()
		setupPasswordTextField()
		setupEmailTextFied()
		setupOrLabel()
		setupLogInButton()
		setupForgotButton()
	}

//	private func setupScrollView() {
//		view.addSubview(scrollView)
//		scrollView.delegate = self
//
//		scrollView.snp.makeConstraints { make in
//			make.edges.equalToSuperview()
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

	private func setupGoogleButton() {
		stackView.addArrangedSubview(googleButton)
	}

	private func setupOrLabel() {
		view.addSubview(orLabel)

		orLabel.snp.makeConstraints { make in
			make.bottom.equalTo(emailTextFied.snp.top).offset(-16)
			make.centerX.equalToSuperview()
		}
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.bottom.equalTo(passwordTextField.snp.top).offset(-32)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupPasswordTextField() {
		view.addSubview(passwordTextField)

		passwordTextField.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalTo(200)
		}
	}

	private func setupLogInButton() {
		view.addSubview(logInButton)

		logInButton.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(64)
			make.height.equalTo(64)
			make.left.right.equalToSuperview().inset(32)
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
		configureStackView()
		configureGoogleButton()
		configureOrLabel()
		configureEmailTextFied()
		configurePasswordTextField()
		configureLogInButton()
		configureForgotButton()
	}

	private func configureView() {
		view.backgroundColor = .white
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}

	private func configureStackView() {
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.distribution = .fillEqually
	}

	private func configureGoogleButton() {
		googleButton.layer.cornerRadius = 8
		googleButton.addTarget(self, action: #selector(pressGoogleButton), for: UIControl.Event.valueChanged)
	}

	private func configureOrLabel() {
		let title = "or"
		orLabel.font = .systemFont(ofSize: 20, weight: .semibold)
		orLabel.textColor = .black
		orLabel.text = title
	}

	private func configureEmailTextFied() {
		emailTextFied.delegate = self
		emailTextFied.placeholder = locolizedStrings.emailPlaceholder.localized()
		emailTextFied.autocorrectionType = .no
		emailTextFied.autocapitalizationType = .none
		emailTextFied.borderStyle = .roundedRect
		emailTextFied.clearButtonMode = .whileEditing
		emailTextFied.tag = TextFieldTag.email.rawValue
		emailTextFied.backgroundColor = .clear
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

	private func configureLogInButton() {
		let title = locolizedStrings.logInButtonTitle.localized()
		logInButton.backgroundColor = .systemPink
		logInButton.layer.cornerRadius = 32
		logInButton.setTitle(title.uppercased(), for: .normal)
		logInButton.setTitleColor(.white, for: .normal)
		logInButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
		logInButton.addTarget(self, action: #selector(pressLogInButton), for: .touchUpInside)
	}

	private func configureForgotButton() {
		let title = locolizedStrings.forgotButtonTitle.localized()
		let attributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: 14, weight: .medium),
			.foregroundColor: UIColor.gray,
			.underlineStyle: NSUnderlineStyle.single.rawValue
]
		let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)

		forgotButton.setAttributedTitle(attributedTitle, for: .normal)
		forgotButton.addTarget(self, action: #selector(pressForgotButton), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc private func pressForgotButton() {
		presenter?.forgotPassword()
	}

	@objc private func pressGoogleButton() {
		GIDSignIn.sharedInstance().signIn()
	}

	@objc func pressLogInButton() {
		var accountInfoModel: AccountInfoModel?

		if let email = emailTextFied.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
			accountInfoModel = AccountInfoModel(email: email, password: password)
		}
		presenter?.login(with: accountInfoModel)
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

	// MARK: - LogViewProtocol

	func loginWithGoogle() {
		presenter?.loginWithGoogle()
	}
}
