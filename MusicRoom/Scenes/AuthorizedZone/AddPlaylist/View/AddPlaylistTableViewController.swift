//
//  AddPlaylistTableViewController.swift
//  MusicRoom
//
//  Created by Mariia on 12.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class AddPlaylistTableViewController: UITableViewController, AddPlaylistViewProtocol, UITextFieldDelegate {

	private enum Constants {
		static let headerHeight: CGFloat = 46
	}

	private var presenter: AddPlaylistPresenterProtocol?
	private lazy var textField = UITextField()

	// MARK: Initialization

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = AddPlaylistPresenter(view: self)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		configureNavigationItem()
		configureTableView()
	}

	// MARK: Private

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.AddPlaylist.navigationTitle.localized
		navigationController?.navigationBar.tintColor = .gray
	}

	private func configureTableView() {
		tableView.registerNibReusable(cellClass: TextFieldAndTwoButtonsTableViewCell.self)
		tableView.registerNibReusable(cellClass: SwitchTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	// MARK: - TableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfRows(in: section) ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let item = presenter?.item(for: indexPath) else { return UITableViewCell() }

		switch item {
		case .name:
			let cell = tableView.dequeueReusableCell(withClass: TextFieldAndTwoButtonsTableViewCell.self, for: indexPath)

			cell.configure(
				with: TextFieldAndTwoButtonsTableViewCellModel(
					state: .onlyTextField,
					textFieldDelegate: self,
					textFieldPlaceholder: LocalizedStrings.AddPlaylist.textFieldPlaceholder.localized
				)
			)
			textField = cell.textField
			return cell

		case .type:
			let cell = tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)
			cell.switchItem.addTarget(self, action: #selector(playlistTypeDidChanged), for: .valueChanged)
			cell.button.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
			cell.configure(
				with: SwitchTableViewCellModel(
					labeltext: LocalizedStrings.AddPlaylist.isPublic.localized,
					buttonImageName: .info
				)
			)

			return cell

		case .button:
			let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
			cell.textLabel?.text = LocalizedStrings.AddPlaylist.buttonTitle.localized
			cell.textLabel?.font = .systemFont(ofSize: 24)
			cell.textLabel?.textColor = .systemPink
			cell.textLabel?.textAlignment = .center
			cell.selectionStyle = .none
			return cell
		}
	}

	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return Constants.headerHeight
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return EmptyView()
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		keyboardResignFirstResponder()
		guard let item = presenter?.item(for: indexPath) else { return }

		switch item {
		case .button:
			guard presenter?.isNameFieldEmpty == false
			else {
				return showBasicAlert(message: LocalizedStrings.AddPlaylist.noNameError.localized)
			}

			presenter?.createPlaylist()
			navigationController?.popViewController(animated: true)

		default:
			break
		}
	}

	// MARK: - Private

	private func keyboardResignFirstResponder() {
		textField.resignFirstResponder()
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let name = textField.text, !name.isEmpty else { return }

		presenter?.updatePlaylistName(with: name)
	}

	// MARK: - Actions

	@objc private func playlistTypeDidChanged() {
		presenter?.updatePlaylistType()
	}

	@objc func showInfo() {
		showBasicAlert(title: LocalizedStrings.Alert.info.localized, message: LocalizedStrings.AddPlaylist.info.localized)
	}
}
