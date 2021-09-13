//
//  TrackTableViewCell.swift
//  MusicRoom
//
//  Created by Mariia on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class LabelsTableViewCell: UITableViewCell {

	let stackView = UIStackView()
	let mainLabel = UILabel()
	let firstAdditionalInfoLabel = UILabel()
	let secondAdditionalInfoLabel = UILabel()

	// MARK: Initializzation

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")
		return nil
	}

	// MARK: - Private

	// MARK: Setup

	func setupUI() {
		setupStackView()
		setupMainLabel()
		setupFirstAdditionalInfoLabel()
		setupSecondAdditionalInfoLabel()
	}

	private func setupStackView() {
		contentView.addSubview(stackView)

		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
			make.top.bottom.equalToSuperview().inset(6)
		}
	}

	private func setupMainLabel() {
		stackView.addArrangedSubview(mainLabel)
	}

	private func setupFirstAdditionalInfoLabel() {
		stackView.addArrangedSubview(firstAdditionalInfoLabel)
	}

	func setupSecondAdditionalInfoLabel() {
		contentView.addSubview(secondAdditionalInfoLabel)

		secondAdditionalInfoLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(GlobalConstants.defaultTrailingOffset)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	func configureUI() {
		configureStackView()
		configureMainLabel()
		configureFirstAdditionalInfoLabel()
		configureSecondAdditionalInfoLabel()
	}

	private func configureStackView() {
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 8
	}

	private func configureMainLabel() {
		mainLabel.font = .systemFont(ofSize: 18, weight: .regular)
		mainLabel.numberOfLines = 0
	}

	private func configureFirstAdditionalInfoLabel() {
		firstAdditionalInfoLabel.font = .systemFont(ofSize: 14, weight: .medium)
		firstAdditionalInfoLabel.numberOfLines = 0
	}

	func configureSecondAdditionalInfoLabel() {
		secondAdditionalInfoLabel.font = .systemFont(ofSize: 12, weight: .regular)
	}
}
