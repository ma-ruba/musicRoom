//
//  LabelsTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class LabelsTableViewCell: UITableViewCell {
	@IBOutlet weak var mainLabel: UILabel!
	@IBOutlet private weak var firstAdditionalInfoLabel: UILabel!
	@IBOutlet private weak var secondAdditionalInfoLabel: UILabel!

	func configure(with model: LabelsTableViewCellModel) {
		mainLabel.text = model.mainLabelText
		firstAdditionalInfoLabel.text = model.firstAdditionalInfoLabelText
		secondAdditionalInfoLabel.text = model.secondAdditionalInfoLabelText
	}
}
