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
			make.right.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureLabel()
		configureSwitchItem()
	}

	private func configureLabel() {
		label.text = "Public"
	}


	private func configureSwitchItem() {
		switchItem.isOn = true
	}
}
