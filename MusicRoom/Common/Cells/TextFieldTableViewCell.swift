//
//  TextFieldTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TextFieldTableViewCell: UITableViewCell {

	let textField = UITextField()

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
		setuptextField()
	}

	private func setuptextField() {
		contentView.addSubview(textField)

		textField.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(16)
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configuretextField()
	}

	private func configuretextField() {
		textField.borderStyle = .roundedRect
		textField.placeholder = "Name"
	}
}
