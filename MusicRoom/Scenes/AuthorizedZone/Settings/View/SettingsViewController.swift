//
//  SettingsViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class SettingsViewController:
	UIViewController,
	SettingsViewProtocol,
	UITableViewDelegate,
	UITableViewDataSource,
	UITextFieldDelegate
{
	private enum Constants {
		static let footerHeight: CGFloat = 46
		static let headerHeight: CGFloat = 46
		static let rowHeight: CGFloat = 56
	}

	private var presenter: SettingsPresenterProtocol?

	private(set) lazy var tableView = UITableView()

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = SettingsPresenter(view: self)
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

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.bottom.top.equalTo(view.safeAreaLayoutGuide)
			make.left.right.equalToSuperview()
		}
	}

	// MARK: Configure

	private func configureUI() {
		configureNavigationItem()
		configureTableView()
	}

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.Settings.navigationTitle.localized
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = Constants.rowHeight
		tableView.registerReusable(cellClass: TextAndButtonTableViewCell.self)
		tableView.registerReusable(cellClass: TextFieldAndTwoButtonsTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: Other

	private func setupDeezerLoginButton(cell: TextAndButtonTableViewCell) {
		cell.button.isHidden = false
		cell.googleButton.isHidden = true
		cell.textedLabel.text = LocalizedStrings.Settings.deezerButtonText.localized
		cell.button.setTitle(LocalizedStrings.Settings.deezerButtonDisabledSatusText.localized, for: .disabled)
		cell.button.setTitle(LocalizedStrings.Settings.deezerButtonEnabledStatusText.localized, for: .normal)
		cell.isUserInteractionEnabled = DeezerSession.sharedInstance.deezerConnect?.userId == nil
		cell.button.addTarget(self, action: #selector(loginToDeezer), for: .touchUpInside)
	}

	private func setupGoogleLoginButton(cell: TextAndButtonTableViewCell) {
		guard let user = Auth.auth().currentUser else { return }

		cell.isUserInteractionEnabled = true
		cell.googleButton.isUserInteractionEnabled = true
		cell.textedLabel.text = LocalizedStrings.Settings.googleButtonText.localized
		cell.button.setTitle(LocalizedStrings.Settings.googleButtonDisabledStatusText.localized, for: .disabled)
		cell.googleButton.addTarget(self, action: #selector(pressGoogleButton), for: .valueChanged)
		if user.providerID == presenter?.googleProviderID {
			cell.button.isHidden = false
			cell.googleButton.isHidden = true
		} else {
			cell.button.isHidden = true
			cell.googleButton.isHidden = false
		}
	}

	private func setupUsernameCell(cell: TextFieldAndTwoButtonsTableViewCell) {
		cell.leftButton.setImage(UIImage(name: .info), for: .normal)
		cell.leftButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)

		cell.rightButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
		let title = LocalizedStrings.Settings.submitButtonTitle.localized
		cell.rightButton.setTitle(title, for: .normal)
		cell.rightButton.setTitleColor(.systemPink, for: .normal)

		cell.selectionStyle = .none
		cell.textField.delegate = self

		guard let username = presenter?.username, username.isEmpty == false else {
			cell.rightButton.isHidden = false
			cell.textField.isUserInteractionEnabled = true
			return
		}

		cell.rightButton.isHidden = true
		cell.leftButton.isHidden = true
		cell.textField.isUserInteractionEnabled = false
		cell.textField.text = username
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let type = SettingsSectionType(rawValue: section) else { return 0 }
		switch type {
		case .accounts:
			return 2

		case .friends:
			return presenter?.username.isEmpty == true ? 1 : 2

		case .logout:
			return 1
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let type = SettingsSectionType(rawValue: indexPath.section) else { return UITableViewCell() }

		// TODO: Ought to remove cases through rows with pure numbers and replace them with abstractions!
		switch type {
		case .accounts:
			let cell = tableView.dequeueReusableCell(withClass: TextAndButtonTableViewCell.self, for: indexPath)
			cell.selectionStyle = .none
			switch indexPath.row {
			case 0:
				setupDeezerLoginButton(cell: cell)

			case 1:
				setupGoogleLoginButton(cell: cell)
				cell.isUserInteractionEnabled = false

			default:
				return UITableViewCell()
			}

			return cell

		case .friends:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withClass: TextFieldAndTwoButtonsTableViewCell.self, for: indexPath)
				setupUsernameCell(cell: cell)

				return cell

			case 1:
				let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
				cell.textLabel?.text = LocalizedStrings.Settings.friendsButtonText.localized
				cell.textLabel?.font = .systemFont(ofSize: 20, weight: .regular)
				cell.textLabel?.textColor = .systemPink
				cell.textLabel?.textAlignment = .center
				cell.selectionStyle = .none

				return cell

			default:
				return UITableViewCell()
			}

		case .logout:
			let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
			cell.textLabel?.text = LocalizedStrings.Settings.logoutButtonText.localized
			cell.textLabel?.textAlignment = .center
			cell.textLabel?.textColor = .systemPink
			cell.textLabel?.font = .systemFont(ofSize: 24, weight: .medium)
			cell.selectionStyle = .none

			return cell
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let type = SettingsSectionType(rawValue: section)

		return type?.name
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return Constants.footerHeight
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return Constants.headerHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let type = SettingsSectionType(rawValue: indexPath.section) else { return }
		switch type {
		case .accounts:
			break

		case .friends:
			switch indexPath.row {
			case 1:
				presenter?.manageFriends()

			default:
				break
			}

		case .logout:
			presenter?.logout()
		}
	}

	// MARK: - UITextFieldDelegate

	func textFieldDidEndEditing(_ textField: UITextField) {
		presenter?.username = textField.text ?? ""
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		textField.text = ""
		return true
	}

	// MARK: - Actions

	@objc private func infoButtonPressed() {
		showBasicAlert(title: LocalizedStrings.Alert.info.localized, message: LocalizedStrings.Settings.info.localized)
	}

	@objc private func submitButtonPressed() {
		presenter?.submitUsername()
		tableView.reloadData()
	}

	@objc private func pressGoogleButton() {
		presenter?.loginToGoogle()
		tableView.reloadData()
	}

	@objc private func loginToDeezer() {
		presenter?.loginToDeezer()
	}
}
