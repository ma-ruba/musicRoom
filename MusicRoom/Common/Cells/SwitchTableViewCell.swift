//
//  SwitchTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {

	let label = UILabel()
	let switchItem = UISwitch()
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
		setupButton()
		setupSwitchItem()
		setupLabel()
	}

	private func setupLabel() {
		contentView.addSubview(label)

		label.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.centerY.equalToSuperview()
			make.right.equalTo(switchItem.snp.left).inset(16)
		}
	}

	private func setupSwitchItem() {
		contentView.addSubview(switchItem)

		switchItem.snp.makeConstraints { make in
			make.right.equalTo(button.snp.left).inset(-16).priority(.required)
			make.right.equalToSuperview().inset(16).priority(.low)
			make.centerY.equalToSuperview()
		}
	}

	private func setupButton() {
		contentView.addSubview(button)

		button.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.size.equalTo(16)
			make.right.equalToSuperview().inset(16)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureLabel()
		configureSwitchItem()
	}

	private func configureLabel() {
		label.font = .systemFont(ofSize: 20)
	}

	private func configureSwitchItem() {
		switchItem.isOn = true
	}
}