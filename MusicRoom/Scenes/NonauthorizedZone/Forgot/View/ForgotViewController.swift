//
//  ForgotViewController.swift
//  MusicRoom
//
//  Created by Mariia on 19.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import Firebase

final class ForgotViewController: UIViewController, ForgotViewProtocol, UITextFieldDelegate {

	private lazy var emailTextFied = UITextField()
	private lazy var sendPasswordButton = UIButton()

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.setNavigationBarHidden(true, animated: true)
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
			make.leading.trailing.equalToSuperview().inset(32)
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
		sendPasswordButton.setTitle(locolizedStrings.sendButtonTitle.localized, for: .normal)
		sendPasswordButton.setTitleColor(.white, for: .normal)
		sendPasswordButton.addTarget(self, action: #selector(didTapSendPasswordButton), for: .touchUpInside)
		sendPasswordButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
	}

	// MARK: - Actions

	@objc func didTapSendPasswordButton() {
		presenter?.send(email: emailTextFied.text)
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
