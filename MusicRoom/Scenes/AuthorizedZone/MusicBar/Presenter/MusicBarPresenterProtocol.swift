//
//  MusicBarPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 08.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol MusicBarPresenterProtocol {
	func buttonPressed()
	func setupPlayerDelegate()
	func setupPlayButtonState()
	func setNewState(_ state: PlayingState)
}
