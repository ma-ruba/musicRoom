//
//  EmptyView.swift
//  MusicRoom
//
//  Created by Mariia on 24.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class EmptyView: UIView {

	// MARK: Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")

		return nil
	}

	// MARK: - Private

	private func setupUI() {
		backgroundColor = .clear
	}
}
