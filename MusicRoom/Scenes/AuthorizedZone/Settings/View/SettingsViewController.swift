//
//  SettingsViewController.swift
//  MusicRoom
//
//  Created by Mariia on 27.12.2020.
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

	private lazy var tableView = UITableView()
	private lazy var textField = UITextField()

	// MARK: Initializzation

	init(handler: TabBarViewProtocol) {
		super.init(nibName: nil, bundle: nil)

		presenter = SettingsPresenter(view: self, handler: handler)
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
			make.leading.trailing.equalToSuperview()
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
		tableView.registerNibReusable(cellClass: TextAndButtonTableViewCell.self)
		tableView.registerNibReusable(cellClass: TextFieldAndTwoButtonsTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: Other

	private func setupDeezerLoginButton(cell: TextAndButtonTableViewCell) {
		let state: TextAndButtonTableViewCellState =
			DeezerManager.sharedInstance.deezerConnect?.userId == nil ? .otherButtonEnabled : .otherButtonDisabled
		cell.configure(
			with: TextAndButtonTableViewCellModel(
				state: state,
				labelText: LocalizedStrings.Settings.deezerButtonText.localized,
				normalButtonText: LocalizedStrings.Settings.deezerButtonEnabledStatusText.localized,
				disabledButtonText: LocalizedStrings.Settings.deezerButtonDisabledSatusText.localized
			)
		)
		cell.button.addTarget(self, action: #selector(loginToDeezer), for: .touchUpInside)
	}

	private func setupGoogleLoginButton(cell: TextAndButtonTableViewCell) {
		guard let user = Auth.auth().currentUser else { return }

		let state: TextAndButtonTableViewCellState = user.providerID == presenter?.googleProviderID ? .otherButtonDisabled : .googleButton
		cell.configure(
			with: TextAndButtonTableViewCellModel(
				state: state,
				labelText: LocalizedStrings.Settings.googleButtonText.localized,
				disabledButtonText: LocalizedStrings.Settings.googleButtonDisabledStatusText.localized
			)
		)
		cell.googleButton.addTarget(self, action: #selector(pressGoogleButton), for: .valueChanged)
	}

	private func setupUsernameCell(cell: TextFieldAndTwoButtonsTableViewCell) {
		let username = presenter?.username
		let state: TextFieldAndTwoButtonsTableViewCellState = username?.isEmpty == false ? .onlyTextField : .textFieldAndTwoButtons
		let isTextFieldEditable = state == .textFieldAndTwoButtons
		cell.configure(
			with: TextFieldAndTwoButtonsTableViewCellModel(
				state: state,
				textFieldDelegate: self,
				leadingButtonImageName: .info,
				trailingButtonText: LocalizedStrings.Settings.submitButtonTitle.localized,
				textFieldPlaceholder: LocalizedStrings.Settings.textFieldPlaceholder.localized,
				trailingButtonTextColor: .systemPink,
				textFieldText: username,
				isTextFieldEditable: isTextFieldEditable
			)
		)
		cell.leadingButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
		cell.trailingButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
		self.textField = cell.textField
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
		textField.resignFirstResponder()
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
