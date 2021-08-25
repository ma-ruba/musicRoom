//
//  UIImage+GradientColor.swift
//  MusicRoom
//
//  Created by Mariia on 16.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {

	/// Перекрасить картинку в градиентные цвета
	func image(withTintGradient gradient: [UIColor]) -> UIImage {
		// Создаем слой градиента
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = CGRect(origin: .zero, size: size)
		let cgColors = gradient.map { $0.cgColor }
		gradientLayer.colors = cgColors

		// Создаем градиент маски
		let mask = CALayer()
		mask.contents = cgImage
		mask.frame = CGRect(origin: .zero, size: size)

		// Применяем маску к градиенту
		gradientLayer.mask = mask
		gradientLayer.masksToBounds = true

		// Отрисовываем градиент на контексте
		UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, scale)
		guard let context = UIGraphicsGetCurrentContext() else { return self }
		gradientLayer.render(in: context)

		// По завершению очистить контекст
		defer {
			UIGraphicsEndImageContext()
		}

		// Генерируем картинку из контекста
		guard let maskedImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal) else { return self }
		return maskedImage
	}
}
