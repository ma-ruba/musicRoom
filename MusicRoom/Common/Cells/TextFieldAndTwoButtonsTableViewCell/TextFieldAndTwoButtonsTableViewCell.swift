//
//  TextFieldAndTwoButtonsTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 14.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class TextFieldAndTwoButtonsTableViewCell: UITableViewCell {
	@IBOutlet private(set) weak var textField: UITextField!
	@IBOutlet private(set) weak var trailingButton: UIButton!
	@IBOutlet private(set) weak var leadingButton: UIButton!

	func configure(with model: TextFieldAndTwoButtonsTableViewCellModel) {
		textField.placeholder = model.textFieldPlaceholder
		textField.text = model.textFieldText
		textField.isUserInteractionEnabled = model.isTextFieldEditable

		switch model.state {
		case .onlyTextField:
			leadingButton.isHidden = true
			trailingButton.isHidden = true
			textField.snp.remakeConstraints { make in
				make.leading.equalToSuperview().offset(GlobalConstants.defaultLeadingOffset)
				make.trailing.equalToSuperview().offset(GlobalConstants.defaultTrailingOffset)
			}

		case .textFieldAndTwoButtons:
			trailingButton.setTitle(model.trailingButtonText, for: .normal)
			trailingButton.setTitleColor(model.trailingButtonTextColor, for: .normal)
			if let iconName = model.leadingButtonImageName {
				leadingButton.setImage(UIImage(name: iconName), for: .normal)
			}
		}
	}
}
