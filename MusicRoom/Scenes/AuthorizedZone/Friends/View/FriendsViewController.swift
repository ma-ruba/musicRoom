//
//  FriendsViewController.swift
//  MusicRoom
//
//  Created by Mariia on 07.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class FriendsViewController:
	UIViewController,
	FriendsViewProtocol,
	UITableViewDelegate,
	UITableViewDataSource
{
	private enum Constants {
		static let footerHeight: CGFloat = 46
		static let headerHeight: CGFloat = 46
	}
	
	private var presenter: FriendsPresenterProtocol?

	private lazy var tableView = UITableView()

	// MARK: Initialization

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = FriendsPresenter(view: self)
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

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.Friends.navigationTitle.localized
		navigationController?.navigationBar.tintColor = .gray
	}

	private func setupUI() {
		setupTableView()
	}

	private func configureUI() {
		configureNavigationItem()
		configureTableView()
	}

	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return FriendsSectionType.allCases.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let type = FriendsSectionType(rawValue: section) else { return 0 }
		
		switch type {
		case .friends:
			return presenter?.friends.count ?? 0

		case .invitations:
			return presenter?.invitations.count ?? 0

		case .pendingInvitations:
			return presenter?.pendingInvitations.count ?? 0

		case .possibleFriends:
			return presenter?.possibleFriends.count ?? 0
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let type = FriendsSectionType(rawValue: section) else { return nil }
		
		switch type {
		case .friends:
			return (presenter?.friends.isEmpty == false ? type.name : nil)

		case .invitations:
			return (presenter?.invitations.isEmpty == false ? type.name : nil)

		case .pendingInvitations:
			return (presenter?.pendingInvitations.isEmpty == false ? type.name : nil)

		case .possibleFriends:
			return (presenter?.possibleFriends.isEmpty == false ? type.name : nil)
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let type = FriendsSectionType(rawValue: indexPath.section) else { return UITableViewCell() }
		let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
		cell.selectionStyle = .none

		switch type {
		case .friends:
			cell.textLabel?.text = presenter?.friends[safe: indexPath.row]?.username

		case .invitations:
			cell.textLabel?.text = presenter?.invitations[safe: indexPath.row]?.username

		case .pendingInvitations:
			cell.textLabel?.text = presenter?.pendingInvitations[safe: indexPath.row]?.username

		case .possibleFriends:
			cell.textLabel?.text = presenter?.possibleFriends[safe: indexPath.row]?.username
		}

		return cell
	}

	// MARK: - TableViewDelegate
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let type = FriendsSectionType(rawValue: section) else { return 0 }
		
		switch type {
		case .friends:
			return (presenter?.friends.isEmpty == false ? Constants.footerHeight : 0)
			
		case .invitations:
			return (presenter?.invitations.isEmpty == false ? Constants.footerHeight :0)

		case .pendingInvitations:
			return (presenter?.pendingInvitations.isEmpty == false ? Constants.footerHeight : 0)

		case .possibleFriends:
			return (presenter?.possibleFriends.isEmpty == false ? Constants.footerHeight : 0)
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let type = FriendsSectionType(rawValue: section) else { return 0 }
		
		switch type {
		case .friends:
			return (presenter?.friends.isEmpty == false ? Constants.headerHeight : 0)
			
		case .invitations:
			return (presenter?.invitations.isEmpty == false ? Constants.headerHeight :0)

		case .pendingInvitations:
			return (presenter?.pendingInvitations.isEmpty == false ? Constants.headerHeight : 0)

		case .possibleFriends:
			return (presenter?.possibleFriends.isEmpty == false ? Constants.headerHeight : 0)
		}
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return EmptyView()
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		guard let type = FriendsSectionType(rawValue: indexPath.section) else { return nil }

		switch type {
		case .possibleFriends:
			let addAction = UIContextualAction(
				style: .normal,
				title: LocalizedStrings.Friends.addActionTitle.localized
			) { [weak self] action, view, completion in
				self?.presenter?.sendInvitation(at: indexPath.row)
			}
			addAction.backgroundColor = .systemGreen

			return UISwipeActionsConfiguration(actions: [addAction])

		case .invitations:
			let acceptAction = UIContextualAction(
				style: .normal,
				title: LocalizedStrings.Friends.acceptActionTitle.localized
			) { [weak self] action, view, completion in
				self?.presenter?.acceptInvitation(at: indexPath.row)
			}
			acceptAction.backgroundColor = .systemGreen

			let rejectAction = UIContextualAction(
				style: .normal,
				title: LocalizedStrings.Friends.rejectActionTitle.localized
			) { [weak self] action, view, completion in
				self?.presenter?.denyInvitation(at: indexPath.row)
			}
			rejectAction.backgroundColor = .systemRed

			return UISwipeActionsConfiguration(actions: [acceptAction, rejectAction])

		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard let type = FriendsSectionType(rawValue: indexPath.section) else { return }
		
		switch editingStyle {
		case .delete:
			switch type {
			case .friends:
				presenter?.deleteFriend(at: indexPath.row)
				
			case .pendingInvitations:
				presenter?.revokeInvitation(at: indexPath.row)
			
			default:
				break
			}
			
		default:
			break
		}
	}

	// MARK: Private

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.remakeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(GlobalConstants.musicBarHeight)
			make.trailing.leading.equalTo(view)
		}
	}

	private func configureTableView() {
		tableView.registerReusable(cellClass: UITableViewCell.self)
		tableView.estimatedRowHeight = 64
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = EmptyView()
	}

	// MARK: - Actions

	@objc private func acceptInvitation(sender: Any) {
		guard let button = sender as? UIButton else { return }
		
		presenter?.acceptInvitation(at: button.tag)
	}

	@objc private func rejectInvitation(sender: Any) {
		guard let button = sender as? UIButton else { return }
		
		presenter?.denyInvitation(at: button.tag)
	}

	// MARK: - FriendsViewProtocol

	func reloadTableView() {
		tableView.reloadData()
	}
}
