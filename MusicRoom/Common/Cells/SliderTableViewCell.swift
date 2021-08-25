//
//  SliderTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class SliderTableViewCell: UITableViewCell {

	let slider = UISlider()
	let mainLabel = UILabel()
	let distanseLabel = UILabel()

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
		setupMainLabel()
		setupDistanceLabel()
		setupSlider()
	}

	private func setupSlider() {
		contentView.addSubview(slider)

		slider.snp.makeConstraints { make in
			make.top.equalTo(mainLabel.snp.bottom)
			make.right.left.equalToSuperview().inset(16)
			make.bottom.equalToSuperview().inset(8)
		}
	}

	private func setupMainLabel() {
		contentView.addSubview(mainLabel)

		mainLabel.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.top.equalToSuperview().offset(8)
		}
	}

	private func setupDistanceLabel() {
		contentView.addSubview(distanseLabel)

		distanseLabel.snp.makeConstraints { make in
			make.right.equalToSuperview().offset(-16)
			make.top.equalTo(mainLabel)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureLabel()
		configureSlider()
	}

	private func configureLabel() {

	}

	private func configureSlider() {

	}
}
