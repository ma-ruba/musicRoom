//
//  ShadowView.swift
//  MusicRoom
//
//  Created by Mariia on 14.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class ShadowView: UIView {

	// MARK: Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")
		return nil
	}

	// MARK: Private

	private func setupUI() {
		
	}
}
