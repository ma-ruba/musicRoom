//
//  TextFieldAndTwoButtonsTableViewCellModel.swift
//  MusicRoom
//
//  Created by 18588255 on 14.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// State of the TextFieldAndTwoButtonsTableViewCell.
enum TextFieldAndTwoButtonsTableViewCellState {

	/// textField is visible. Buttons are hidden.
	case onlyTextField

	/// Both textField and buttons are visible.
	case textFieldAndTwoButtons
}

/// Model for TextFieldAndTwoButtonsTableViewCell configuration.
struct TextFieldAndTwoButtonsTableViewCellModel {
	let state: TextFieldAndTwoButtonsTableViewCellState
	let trailingButtonTextColor: UIColor
	let textFieldDelegate: UITextFieldDelegate
	let isTextFieldEditable: Bool
	let leadingButtonImageName: ImageList?
	let trailingButtonText: String?
	let textFieldPlaceholder: String?
	let textFieldText: String?

	// MARK: Initialization

	init(
		state: TextFieldAndTwoButtonsTableViewCellState,
		textFieldDelegate: UITextFieldDelegate,
		leadingButtonImageName: ImageList? = nil,
		trailingButtonText: String? = nil,
		textFieldPlaceholder: String? = nil,
		trailingButtonTextColor: UIColor = .black,
		textFieldText: String? = nil,
		isTextFieldEditable: Bool = true
	) {
		self.state = state
		self.textFieldDelegate = textFieldDelegate
		self.leadingButtonImageName = leadingButtonImageName
		self.trailingButtonText = trailingButtonText
		self.textFieldPlaceholder = textFieldPlaceholder
		self.trailingButtonTextColor = trailingButtonTextColor
		self.textFieldText = textFieldText
		self.isTextFieldEditable = isTextFieldEditable
	}
}
