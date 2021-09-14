//
//  TextAndButtonTableViewCellModel.swift
//  MusicRoom
//
//  Created by 18588255 on 14.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// State of the cell
enum TextAndButtonTableViewCellState {

	/// Google button is visible. Other button is hidden.
	case googleButton

	/// Google button is hidden. Other button is visible and enabled.
	case otherButtonEnabled

	/// Google button is hidden. Other button is visible and disabled.
	case otherButtonDisabled
}

/// Model for TextAndButtonTableViewCell configuration.
struct TextAndButtonTableViewCellModel {
	let state: TextAndButtonTableViewCellState
	let labelText: String
	let normalButtonText: String?
	let disabledButtonText: String?

	// MARK: Initialization

	init(
		state: TextAndButtonTableViewCellState,
		labelText: String,
		normalButtonText: String? = nil,
		disabledButtonText: String? = nil
	) {
		self.state = state
		self.normalButtonText = normalButtonText
		self.labelText = labelText
		self.disabledButtonText = disabledButtonText
	}
}
