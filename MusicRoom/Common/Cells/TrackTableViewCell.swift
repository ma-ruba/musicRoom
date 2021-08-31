//
//  TrackTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TrackTableViewCell: UITableViewCell {

	let stackView = UIStackView()
	let titleLabel = UILabel()
	let authorLabel = UILabel()
	let duartionLabel = UILabel()

	var track: Track? {
		didSet {
			configureUI()
		}
	}

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
		setupTitleLabel()
		setupAuthorLabel()
		setupDurationLabel()
	}

	private func setupStackView() {
		contentView.addSubview(stackView)

		stackView.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.top.bottom.equalToSuperview().inset(6)
		}
	}

	private func setupTitleLabel() {
		stackView.addArrangedSubview(titleLabel)
	}

	private func setupAuthorLabel() {
		stackView.addArrangedSubview(authorLabel)
	}

	func setupDurationLabel() {
		contentView.addSubview(duartionLabel)

		duartionLabel.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: Configuration

	func configureUI() {
		configureStackView()
		configureTitleLabel()
		configureAuthorLabel()
		configureDurationLabel()
	}

	private func configureStackView() {
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.spacing = 8
	}

	private func configureTitleLabel() {
		titleLabel.text = track?.name
		titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
		titleLabel.numberOfLines = 0
	}

	private func configureAuthorLabel() {
		authorLabel.text = track?.creator
		authorLabel.font = .systemFont(ofSize: 14, weight: .medium)
		authorLabel.numberOfLines = 0
	}

	func configureDurationLabel() {
		guard let track = track else { return }
		duartionLabel.text = String(format: "%01d:%02d", track.duration / 60, track.duration % 60)
		duartionLabel.font = .systemFont(ofSize: 12, weight: .regular)
	}

}
