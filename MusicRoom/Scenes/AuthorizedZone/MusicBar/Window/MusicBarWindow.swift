//
//  MusicBarWindow.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

final class MusicBarWindow: UIWindow {

	// MARK: Internal

	override var rootViewController: UIViewController? {
		didSet {
			isHidden = false
		}
	}

	// MARK: Lifecircle

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupInitialState()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupInitialState()
	}

	// MARK: Private

	private func setupInitialState() {
		backgroundColor = .clear
		isOpaque = false
		windowLevel = WindowLevelConstants.musicBar
		makeKeyAndVisible()
	}
}
