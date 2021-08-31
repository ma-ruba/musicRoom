//
//  TextFieldAndTwoButtonsTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 10.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TextFieldAndTwoButtonsTableViewCell: UITableViewCell {
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
		setupLeftButton()
		setupTextField()
		setupRightButton()
	}

	private func setupTextField() {
		contentView.addSubview(textField)

		textField.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalTo(leftButton.snp.right).offset(16)
		}
	}

	private func setupLeftButton() {
		contentView.addSubview(leftButton)

		leftButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(16)
			make.size.equalTo(36)
			make.top.bottom.equalToSuperview().inset(16)
		}
	}

	private func setupRightButton() {
		contentView.addSubview(rightButton)

		rightButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().offset(-16)
			make.left.equalTo(textField.snp.right).offset(16)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureTextField()
	}

	private func configureTextField() {
		textField.textColor = .black
		textField.font = .systemFont(ofSize: 18, weight: .regular)
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		textField.borderStyle = .roundedRect
		textField.clearButtonMode = .whileEditing
	}
}
