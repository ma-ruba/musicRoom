//
//  SettingsViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAnalytics

final class SettingsViewController:
	UIViewController,
	UITableViewDelegate,
	UITableViewDataSource,
	TextFieldAndTwoButtonsTableViewCellDelegate,
	GIDSignInDelegate
{

	private(set) lazy var googleButton = GIDSignInButton()
	private(set) lazy var tableView = UITableView()

	var usernameRef: DatabaseReference?
	var usernameHandle: UInt?
	var username: String = ""

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

		configureDatabase()
		GIDSignIn.sharedInstance()?.delegate = self

		setupUI()
		configureUI()
	}

	override func viewDidDisappear(_ animated: Bool) {
		if let handle = usernameHandle {
			usernameRef?.removeObserver(withHandle: handle)
		}
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(55)
			make.left.right.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
		}
	}

	// MARK: Configure

	private func configureUI() {
		view.backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
		navigationItem.title = "Settings"

		configureTableView()
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 90
		tableView.registerReusable(cellClass: TextAndButtonTableViewCell.self)
		tableView.registerReusable(cellClass: TextFieldAndTwoButtonsTableViewCell.self)
		tableView.registerReusable(cellClass: UITableViewCell.self)
		tableView.backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
	}

	// MARK: Other

	private func configureDatabase() {
		if let uid = Auth.auth().currentUser?.uid {
			usernameRef = Database.database().reference(withPath: "users/" + uid + "/username")
		}

		self.usernameHandle = self.usernameRef?.observe(.value, with: { snapshot in
			if let username = snapshot.value as? String {
				self.username = username
				self.tableView.reloadData()
			}
		})
	}

	private func loginToDeezer() {
		DeezerSession.sharedInstance.deezerConnect?.authorize([
			DeezerConnectPermissionBasicAccess,
			DeezerConnectPermissionManageLibrary,
			DeezerConnectPermissionOfflineAccess
		])
	}

	private func logoutFromApp() {
		do {
			GIDSignIn.sharedInstance().signOut()
			LoginManager().logOut()
			try Auth.auth().signOut()
			DeezerSession.sharedInstance.clearMusic()
			DeezerSession.sharedInstance.deezerConnect?.logout()
			Analytics.logEvent("logging_out", parameters: Log.defaultInfo())
			dismiss(animated: true, completion: nil)
		} catch let signOutError as NSError {
			print ("Error: \(signOutError)")
			self.showBasicAlert(title: "Logout failed", message: "Something went wrong")
		}
	}

	private func setupDeezerLoginButton(cell: TextAndButtonTableViewCell) {
		cell.button.isHidden = true
		cell.deezerButton.isHidden = true
		cell.textedLabel.text = "Deezer"
		if DeezerSession.sharedInstance.deezerConnect?.userId != nil {
			cell.buttonLabel.text = "Logged to Deezer"
			cell.buttonLabel.textColor = .systemGreen
			cell.isUserInteractionEnabled = false
		} else {
			cell.buttonLabel.text = "Login to Deezer"
			cell.buttonLabel.textColor = .blue
			cell.isUserInteractionEnabled = true
		}
	}

	private func setupGoogleLoginButton(cell: TextAndButtonTableViewCell) {
		guard let user = Auth.auth().currentUser else { return }

		cell.button.isHidden = true
		cell.textedLabel.text = "Google"
		if user.providerID == "google.com" {
			cell.buttonLabel.text = "Logged to Google"
			cell.buttonLabel.textColor = .green
			cell.buttonLabel.isHidden = false
			cell.deezerButton.isHidden = true
		} else {
			cell.buttonLabel.isHidden = true
			cell.deezerButton.isHidden = false
		}
	}

	private func setupUsernameField(cell: TextFieldAndTwoButtonsTableViewCell) {
		if username.isEmpty {
			cell.rightButton.isHidden = false
			cell.rightButton.setTitle("Submit", for: .normal)
			cell.rightButton.setTitleColor(.blue, for: .normal)
			cell.textField.isUserInteractionEnabled = true
		} else {
			cell.rightButton.isHidden = true
			cell.textField.isUserInteractionEnabled = false
			cell.textField.text = username
		}
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 2

		case 1:
			return username.isEmpty ? 1 : 2

		default:
			return 1
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withClass: TextAndButtonTableViewCell.self, for: indexPath)
			switch indexPath.row {
			case 1:
				setupGoogleLoginButton(cell: cell)
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				cell.isUserInteractionEnabled = false

			default:
				setupDeezerLoginButton(cell: cell)
				cell.isSelected = false
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

			}
			cell.backgroundColor = .white
			return cell

		case 1:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withClass: TextFieldAndTwoButtonsTableViewCell.self, for: indexPath)
				cell.backgroundColor = .white
				setupUsernameField(cell: cell)
				cell.isUserInteractionEnabled = false
				cell.layer.cornerRadius = 12
				if !username.isEmpty {
					cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
				}

				return cell

			default:
				let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
				cell.textLabel?.text = "Manage friends"
				cell.textLabel?.textColor = .blue
				cell.backgroundColor = .white
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				cell.isSelected = false

				return cell
			}

		case 2:
			let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
			cell.textLabel?.text = "Logout"
			cell.textLabel?.textAlignment = .center
			cell.textLabel?.textColor = .red
			cell.backgroundColor = .white
			cell.layer.cornerRadius = 12

			return cell

		default:
			return UITableViewCell()
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 46
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = HeaderView()
		view.backgroundColor = .clear

		switch section {
		case 0:
			view.label.text = "Accounts".uppercased()

		case 1:
			view.label.text = "Friends".uppercased()

		case 2:
			view.label.text = "Logout".uppercased()

		default:
			view.label.text = nil
		}

		return view
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear

		return view
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				loginToDeezer()

			default:
				break
			}

		case 1:
			switch indexPath.row {
			case 1:
				let viewController = FriendsViewController()
				let navigationController = UINavigationController(rootViewController: viewController)
				present(navigationController, animated: true)

			default:
				break
			}

		case 2:
			logoutFromApp()

		default:
			break
		}
	}

	// MARK: - TextFieldAndTwoButtonsTableViewCellDelegate

	func textFieldAndTwoButtonsTableViewCellDidTapLeftButton(_ cell: TextFieldAndTwoButtonsTableViewCell) {
		showBasicAlert(message: "Create your username to share playlists and events with friends")
	}

	func textFieldAndTwoButtonsTableViewCellDidTapRightButton(_ cell: TextFieldAndTwoButtonsTableViewCell) {
		username = cell.textField.text ?? ""
		setupUsernameField(cell: cell)
	}

	// MARK: -

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextAndButtonTableViewCell else {
			return
		}
		setupGoogleLoginButton(cell: cell)
	}
}
