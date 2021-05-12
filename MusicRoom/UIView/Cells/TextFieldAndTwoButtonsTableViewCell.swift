//
//  TextFieldAndTwoButtonsTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 10.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

protocol TextFieldAndTwoButtonsTableViewCellDelegate: AnyObject {
	func textFieldAndTwoButtonsTableViewCellDidTapLeftButton(_ cell: TextFieldAndTwoButtonsTableViewCell)
	func textFieldAndTwoButtonsTableViewCellDidTapRightButton(_ cell: TextFieldAndTwoButtonsTableViewCell)
}

final class TextFieldAndTwoButtonsTableViewCell: UITableViewCell {

	weak var delegate: TextFieldAndTwoButtonsTableViewCellDelegate?

	let textField = UITextField()
	let leftButton = UIButton()
	let rightButton = UIButton()

	// MARK: Initializzation

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupUI()
		configureUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")
		return nil
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTextField()
		setupLeftButton()
		setupRightButton()
	}

	private func setupTextField() {
		contentView.addSubview(textField)

		textField.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	private func setupLeftButton() {
		contentView.addSubview(leftButton)

		leftButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(16)
			make.height.equalTo(24)
			make.width.equalTo(36)
		}
	}

	private func setupRightButton() {
		contentView.addSubview(rightButton)

		rightButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-16)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureTextField()
		configureLeftButton()
	}

	private func configureTextField() {
		textField.textColor = .black
		textField.font = .systemFont(ofSize: 18, weight: .medium)
		textField.placeholder = "Your username"
		textField.borderStyle = .roundedRect
	}

	private func configureLeftButton() {
		leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
		leftButton.setImage(UIImage(name: .info), for: .normal)
	}

	private func configureRightButton() {
		rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
		rightButton.setTitle("Submit", for: .normal)
	}

	// MARK: - Actions

	@objc private func leftButtonPressed() {
		delegate?.textFieldAndTwoButtonsTableViewCellDidTapLeftButton(self)
	}

	@objc private func rightButtonPressed() {
		guard let uid = Auth.auth().currentUser?.uid, let username = textField.text else {
			return
		}

		let ref = Database.database().reference()
		let updatedUserData = ["users/\(uid)/username": username, "usernames/\(username)": uid] as [String : Any]

		ref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref) -> Void in
			if error != nil {
				print("Error updating data: \(error.debugDescription)")
			}
//			else {
//				Analytics.logEvent("created_username", parameters: Log.defaultInfo())
//			}
		})

		delegate?.textFieldAndTwoButtonsTableViewCellDidTapRightButton(self)
	}
}
