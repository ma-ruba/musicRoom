//
//  SignPresenterProtocol.swift
//  MusicRoom
//
//  Created by Мария on 05.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for SignPresenter.
protocol SignPresenterProtocol: AnyObject {

	/// Method creates account.
	func createAccount(with model: SignViewController.AccountInfoModel?)
}
