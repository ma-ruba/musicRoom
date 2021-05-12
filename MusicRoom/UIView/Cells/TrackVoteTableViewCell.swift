//
//  TrackVoteTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 03.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TrackVoteTableViewCell: UITableViewCell {

	let leftButton = UIButton()
	let rightButton = UIButton()
	let scoreLabel = UILabel()
	let stackView = UIStackView()
	let titleLabel = UILabel()
	let authorLabel = UILabel()

	var track: Track? {
		didSet {
			configureUI()
		}
	}

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

	func setupUI() {


		setupStackView()
		setupTitleLabel()
		setupAuthorLabel()
		setupLeftButton()
		setupRightButton()
		setupScoreLabel()
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

	func setupScoreLabel() {
		contentView.addSubview(scoreLabel)

		scoreLabel.snp.makeConstraints { make in
			make.top.equalTo(leftButton.snp.bottom).offset(4)
			make.right.equalToSuperview().inset(46)
			make.bottom.equalToSuperview().inset(1)
		}
	}

	private func setupLeftButton() {
		contentView.addSubview(leftButton)

		leftButton.snp.makeConstraints { make in
			make.left.equalTo(stackView.snp.right)
			make.size.equalTo(24)
			make.centerY.equalToSuperview()
		}
	}

	private func setupRightButton() {
		contentView.addSubview(rightButton)

		rightButton.snp.makeConstraints { make in
			make.size.equalTo(24)
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().inset(16)
			make.left.equalTo(leftButton.snp.right).offset(16)
		}
	}

	// MARK: Configuration

	func configureUI() {
		configureStackView()
		configureTitleLabel()
		configureAuthorLabel()
		configureLeftButton()
		configureRightButton()
		configureScoreLabel()
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

	func configureScoreLabel() {

	}

	private func configureLeftButton() {
		
	}

	private func configureRightButton() {

	}
}
