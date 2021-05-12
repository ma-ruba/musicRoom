//
//  FriendsTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class FriendsTableViewCell: UITableViewCell {

	let acceptButton = UIButton()
	let denyButton = UIButton()
	let addButton = UIButton()
	let label = UILabel()

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
		setupAcceptButton()
		setupDenyButton()
		setupAddButton()
		setupLabel()
	}

	private func setupAcceptButton() {
		contentView.addSubview(acceptButton)

		acceptButton.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(16)
			make.size.equalTo(24)
			make.centerY.equalToSuperview()
		}
	}

	private func setupDenyButton() {
		contentView.addSubview(denyButton)

		denyButton.snp.makeConstraints { make in
			make.size.equalTo(acceptButton)
			make.right.equalTo(acceptButton.snp.left).inset(8)
			make.centerY.equalTo(acceptButton)
		}
	}

	private func setupAddButton() {
		contentView.addSubview(addButton)

		addButton.snp.makeConstraints { make in
			make.right.equalTo(acceptButton)
			make.size.equalTo(acceptButton)
			make.centerY.equalTo(acceptButton)
		}
	}

	private func setupLabel() {
		contentView.addSubview(label)

		label.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.right.equalTo(denyButton.snp.left)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureAcceptButton()
		configureDenyButton()
		configureAddButton()
		configureLabel()
	}

	private func configureAcceptButton() {
		acceptButton.setImage(UIImage(name: .accept), for: .normal)
	}

	private func configureDenyButton() {
		denyButton.setImage(UIImage(name: .deny), for: .normal)
	}

	private func configureAddButton() {
		addButton.setImage(UIImage(name: .add), for: .normal)
	}

	private func configureLabel() {

	}
}
