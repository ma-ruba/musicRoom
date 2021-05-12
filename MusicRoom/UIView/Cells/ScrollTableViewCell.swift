//
//  ScrollTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 26.12.2020.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class ScrollTableViewCell: UITableViewCell {

	let scroll = UIDatePicker()
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
		setupLabel()
		setupScroll()
	}

	private func setupScroll() {
		contentView.addSubview(scroll)

		scroll.snp.makeConstraints { make in
			make.left.equalTo(label.snp.right)
			make.right.equalToSuperview().inset(16)
			make.top.bottom.equalToSuperview().inset(16)
		}
	}

	private func setupLabel() {
		contentView.addSubview(label)

		label.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureLabel()
		configureScroll()
	}

	private func configureLabel() {

	}

	private func configureScroll() {
		scroll.datePickerMode = .dateAndTime
	}
}
