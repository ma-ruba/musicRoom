//
//  TextAndButtonTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 14.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit
import GoogleSignIn

final class TextAndButtonTableViewCell: UITableViewCell {
	@IBOutlet private(set) weak var button: UIButton!
	@IBOutlet private weak var label: UILabel!
	let googleButton = GIDSignInButton()

	func configure(with model: TextAndButtonTableViewCellModel) {
		label.text = model.labelText
		button.setTitle(model.normalButtonText, for: .normal)
		button.setTitle(model.disabledButtonText, for: .disabled)
		button.setTitleColor(.systemPink, for: .normal)
		button.setTitleColor(.darkGray, for: .disabled)

		switch model.state {
		case .googleButton:
			setupGoogleButton()
			button.isHidden = true
			googleButton.isHidden = false

		case .otherButtonEnabled:
			button.isHidden = false
			button.isEnabled = true
			googleButton.isHidden = true

		case .otherButtonDisabled:
			button.isHidden = false
			button.isEnabled = false
			googleButton.isHidden = true
		}
	}

	// MARK: - Private

	private func setupGoogleButton() {
		contentView.addSubview(googleButton)

		googleButton.snp.makeConstraints { make in
			make.trailing.top.bottom.equalToSuperview().inset(16)
			make.width.equalTo(200)
		}
	}
}
