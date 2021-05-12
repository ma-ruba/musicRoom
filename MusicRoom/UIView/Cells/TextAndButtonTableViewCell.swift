//
//  TextAndButtonTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import SnapKit
import GoogleSignIn

final class TextAndButtonTableViewCell: UITableViewCell {

	let textedLabel = UILabel()
	let deezerButton = GIDSignInButton()
	let buttonLabel = UILabel()
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
		setupDeezerButton()
		setupButtonLabel()
		setupButton()
	}

	private func setupButton() {
		contentView.addSubview(button)

		button.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(16)
			make.size.equalTo(36)
			make.centerY.equalToSuperview()
		}
	}

	private func setupTextedLabel() {
		contentView.addSubview(textedLabel)

		textedLabel.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.center.equalToSuperview()
		}
	}

	private func setupDeezerButton() {
		contentView.addSubview(deezerButton)

		deezerButton.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(16)
			make.height.equalTo(48)
			make.width.equalTo(230)
		}
	}

	private func setupButtonLabel() {
		contentView.addSubview(buttonLabel)

		buttonLabel.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureTextedLabel()
		configureButton()
	}

	private func configureTextedLabel() {
		textedLabel.textColor = .black
		textedLabel.font = .systemFont(ofSize: 18, weight: .medium)
	}

	private func configureButton() {
		deezerButton.layer.cornerRadius = 8
	}
}
