//
//  LogPresenterProtocol.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol LogPresenterProtocol {
	func makeSetups()
	func forgotPassword()
	func login(with model: LogViewController.AccountInfoModel?)
	func loginWithGoogle()
}
