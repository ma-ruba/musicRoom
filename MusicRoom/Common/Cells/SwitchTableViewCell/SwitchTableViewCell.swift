//
//  SwitchTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 14.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {

	
	@IBOutlet private weak var label: UILabel!
	@IBOutlet private(set) weak var button: UIButton!
	@IBOutlet private(set) weak var switchItem: UISwitch!

	func configure(with model: SwitchTableViewCellModel) {
		button.setImage(UIImage(name: model.buttonImageName), for: .normal)
		label.text = model.labeltext
	}
}
