//
//  SnapshotHandler.swift
//  MusicRoom
//
//  Created by 18588255 on 04.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation

protocol SnapshotHandler {
	func snapshotChanged(snapshot: DataSnapshot)
}