//
//  StartPresenterProtocol.swift
//  MusicRoom
//
//  Created by Мария on 04.06.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for StartPresenter.
protocol StartPresenterProtocol: AnyObject {

	/// Method redirects to login page.
	func logIn()

	/// Method redirects to signing page.
	func signUp()
}
