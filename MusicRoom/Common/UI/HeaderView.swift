//
//  HeaderView.swift
//  MusicRoom
//
//  Created by Mariia on 15.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class HeaderView: UIView {

	let label = UILabel()

	// MARK: Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		configureUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")
		return nil
	}

	// MARK: - Private

	private func setupUI() {
		setupLabel()
	}

	private func setupLabel() {
		addSubview(label)

		label.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
			make.centerY.equalToSuperview()
		}
	}

	private func configureUI() {
		configureLabel()
	}

	private func configureLabel() {
		label.textColor = .black
		label.font = .systemFont(ofSize: 18, weight: .medium)
	}

}
