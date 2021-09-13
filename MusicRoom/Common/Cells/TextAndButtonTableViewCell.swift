//
//  TextAndButtonTableViewCell.swift
//  MusicRoom
//
//  Created by Mariia on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import GoogleSignIn

final class TextAndButtonTableViewCell: UITableViewCell {

	let textedLabel = UILabel()
	let googleButton = GIDSignInButton()
	let button = UIButton()


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
		setupTextedLabel()
		setupGoogleButton()
		setupButton()
	}

	private func setupButton() {
		contentView.addSubview(button)

		button.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}
	}

	private func setupTextedLabel() {
		contentView.addSubview(textedLabel)

		textedLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
			make.centerY.equalToSuperview()
		}
	}

	private func setupGoogleButton() {
		contentView.addSubview(googleButton)

		googleButton.snp.makeConstraints { make in
			make.trailing.top.bottom.equalToSuperview().inset(16)
			make.width.equalTo(200)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureTextedLabel()
		configureButton()
	}

	private func configureTextedLabel() {
		textedLabel.textColor = .black
		textedLabel.font = .systemFont(ofSize: 20, weight: .regular)
	}

	private func configureButton() {
		button.setTitleColor(.systemPink, for: .normal)
		button.setTitleColor(.darkGray, for: .disabled)
	}
}
