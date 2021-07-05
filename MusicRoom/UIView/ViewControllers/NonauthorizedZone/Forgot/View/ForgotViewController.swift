//
//  ForgotViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 19.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import Firebase

final class ForgotViewController: UIViewController, ForgotViewProtocol, UITextFieldDelegate {

	private(set) lazy var emailTextFied = UITextField()
	private(set) lazy var sendPasswordButton = UIButton()

	private var presenter: ForgotPresenterProtocol?

	private let locolizedStrings: LocalizedStrings.Forgot.Type = LocalizedStrings.Forgot.self

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = ForgotPresenter(view: self)
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
		let titleLabel = UILabel()
		titleLabel.text = locolizedStrings.title.localized
		titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
		navigationItem.titleView = titleLabel
	}

	// MARK: Setup

	private func setupUI() {
		setupEmailTextFied()
		setupSendPasswordButton()
	}

	private func setupEmailTextFied() {
		view.addSubview(emailTextFied)

		emailTextFied.snp.makeConstraints { make in
			make.center.equalToSuperview()
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
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}

	private func configureEmailTextFied() {
		emailTextFied.placeholder = locolizedStrings.title.localized
		emailTextFied.autocorrectionType = .no
		emailTextFied.autocapitalizationType = .none
		emailTextFied.borderStyle = .roundedRect
		emailTextFied.delegate = self
		emailTextFied.clearButtonMode = .whileEditing
	}

	private func configuresSendPasswordButton() {
		sendPasswordButton.backgroundColor = .systemPink
		sendPasswordButton.layer.cornerRadius = 32
		sendPasswordButton.setTitle("Send", for: .normal)
		sendPasswordButton.setTitleColor(.white, for: .normal)
		sendPasswordButton.addTarget(self, action: #selector(didTapSendPasswordButton), for: .touchUpInside)
		sendPasswordButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
	}

	// MARK: - Actions

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

	// MARK: - BasicViewProtocol

	func showAlert(message: String) {
		showBasicAlert(message: message)
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
		guard let result = Validator.validate(email: textField.text) else {
			return true
		}
		if textField.text?.isEmpty == false {
			showAlert(message: result)
			textField.text = ""
			return false
		}

		return true
	}
}
