//
//  TabBarViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

	let childViewController = MusicBarViewController()

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		let firstViewController = SettingsViewController()
		let secondViewController = PlaylistTableViewController()
		let thirdViewController = EventsTableViewController()

		let firstImage = UIImage(name: .settings)
		let secondImage = UIImage(name: .playlist)
		let thirdImage = UIImage(name: .events)

		firstViewController.tabBarItem = UITabBarItem(title: "Settings", image: firstImage, tag: 0)
		secondViewController.tabBarItem = UITabBarItem(title: "Playlist", image: secondImage, tag: 1)
		thirdViewController.tabBarItem = UITabBarItem(title: "Events", image: thirdImage, tag: 2)

		let tabBarList = [secondViewController, thirdViewController, firstViewController]

		viewControllers = tabBarList.map { UINavigationController(rootViewController: $0) }

		setupChildViewController()
	}

	private func setupChildViewController() {
		let viewController = MusicBarViewController()
		addChild(viewController)

		view.addSubview(viewController.view)
		viewController.didMove(toParent: self)

		viewController.view.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
			make.right.left.equalToSuperview()
			make.height.equalTo(55)
		}
	}

}
