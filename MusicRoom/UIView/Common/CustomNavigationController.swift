//
//  CustomNavigationController.swift
//  MusicRoom
//
//  Created by Mariia on 12.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

final class CustomNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		modalPresentationStyle = .fullScreen
		navigationBar.barTintColor = .clear
		navigationBar.tintColor = .white
		navigationBar.barStyle = .black
	}
}
