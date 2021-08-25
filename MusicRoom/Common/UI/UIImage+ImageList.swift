//
//  UIImage+ImageList.swift
//  MusicRoom
//
//  Created by 18588255 on 11.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	convenience init?(name: ImageList) {
		self.init(named: name.rawValue)
	}
}
