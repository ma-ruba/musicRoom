//
//  UIColor+AlphaComponent.swift
//  MusicRoom
//
//  Created by Mariia on 16.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

extension UIColor {
	enum Alpha: CGFloat {
		case none = 0.0
		case scanty = 0.1
		case weak = 0.16
		case low = 0.3
		case lowMedium = 0.4
		case medium = 0.6
		case mediumFull = 0.8
		case full = 1.0
	}

	/// Returns the red, green, blue, and alpha components
	///
	/// Returns nil if the conversion to the RGBA colorspace wasn't successful
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
		var values: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		let isConversionSuccessful = getRed(&values.0, green: &values.1, blue: &values.2, alpha: &values.3)

		guard isConversionSuccessful else {
			return nil
		}

		return values
	}

	func with(alpha: Alpha) -> UIColor {
		return withAlphaComponent(alpha.rawValue)
	}
}
