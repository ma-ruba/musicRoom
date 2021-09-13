//
//  TextFieldAndTwoButtonsTableViewCell.swift
//  MusicRoom
//
//  Created by Mariia on 10.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TextFieldAndTwoButtonsTableViewCell: UITableViewCell {
	let textField = UITextField()
	let leadingButton = UIButton()
	let trailingButton = UIButton()

	// MARK: Initializzation

	override func willMove(toSuperview newSuperview: UIView?) {
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
		setupLeadingButton()
		setupTextField()
		setupTrailingButton()
	}

	private func setupTextField() {
		contentView.addSubview(textField)

		textField.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			if leadingButton.isHidden {
				make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
			} else {
				make.leading.equalTo(leadingButton.snp.trailing).offset(GlobalConstants.defaultLeadingOffset)
			}

			if trailingButton.isHidden {
				make.trailing.equalToSuperview().offset(GlobalConstants.defaultTrailingOffset)
			}
		}
	}

	private func setupLeadingButton() {
		contentView.addSubview(leadingButton)

		leadingButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
			make.size.equalTo(36)
			make.top.bottom.equalToSuperview().inset(16)
		}
	}

	private func setupTrailingButton() {
		contentView.addSubview(trailingButton)

		trailingButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().offset(GlobalConstants.defaultTrailingOffset)
			make.leading.equalTo(textField.snp.trailing).offset(GlobalConstants.defaultLeadingOffset)
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
