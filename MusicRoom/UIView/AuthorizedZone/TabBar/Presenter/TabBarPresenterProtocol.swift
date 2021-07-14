//
//  TabBarPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 13.07.2021.
//  Copyright © 2021 School21. All rights reserved.
//

protocol TabBarPresenterProtocol {
	var viewControllers: [UIViewController] { get }
	var tabBarItems: [TabBarModel.TabBarItem] { get }
}
