//
//  LogPresenterProtocol.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for LogPresenter.
protocol LogPresenterProtocol {

	/// Method makes required setups.
	func makeSetups()

	/// Method resets password.
	func forgotPassword()

	/// Method loggs into the app.
	func login(with model: LogViewController.AccountInfoModel?)

	/// Method loggs into the app with Google.
	func loginWithGoogle()
}
