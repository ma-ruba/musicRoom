//
//  TabBarViewController.swift
//  MusicRoom
//
//  Created by Mariia on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController, TabBarViewProtocol {
	private var presenter: TabBarPresenterProtocol?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)

		presenter = TabBarPresenter(view: self)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureView()
		setupTabBar()
		configureTabBarAppearance()
		presenter?.setupMusicBar()
	}

	// MARK: - Private

	private func setupTabBar() {
		guard let tabBarItems = presenter?.tabBarItems,
			let tabBarList = presenter?.viewControllers
		else {
			return
		}

		var items: [UITabBarItem] = []

		for tabBarItem in tabBarItems {
			let item = UITabBarItem(
				title: tabBarItem.name,
				image: UIImage(name: tabBarItem.image)?.withTintColor(.gray, renderingMode: .alwaysTemplate),
				selectedImage: UIImage(name: tabBarItem.image)?.image(withTintGradient: [.gray, .systemPink])
			)
			items.append(item)
		}

		for (tabBarItem, viewController) in zip(items, tabBarList) {
			configureAppearance(forTabBarItem: tabBarItem)
			viewController.tabBarItem = tabBarItem
		}

		viewControllers = tabBarList.map { UINavigationController(rootViewController: $0) }
	}

	private func configureAppearance(forTabBarItem tabBarItem: UITabBarItem) {
		var attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]

		attributes[.foregroundColor] = UIColor.gray
		tabBarItem.setTitleTextAttributes(attributes, for: .normal)

		attributes[.foregroundColor] = UIColor.systemPink
		tabBarItem.setTitleTextAttributes(attributes, for: .selected)
	}

	private func configureView() {
		view.backgroundColor = .white
	}

	private func configureTabBarAppearance() {
		let barAppearance = UITabBar.appearance()
		barAppearance.shadowImage = UIImage()
		barAppearance.backgroundImage = UIImage()
		barAppearance.isTranslucent = false
		barAppearance.unselectedItemTintColor = UIColor.darkGray.with(alpha: .low)
	}
	
	// MARK: - TabBarViewProtocol
	
	func dismiss() {
		dismiss(animated: true)
	}
}
