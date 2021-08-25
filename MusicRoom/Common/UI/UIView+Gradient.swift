//
//  UIView+Gradient.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit

extension UIView {
	func applyGradient(with colors: [UIColor]) {
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = colors.map { $0.cgColor }
		layer.insertSublayer(gradient, at: 0)
	}
}
