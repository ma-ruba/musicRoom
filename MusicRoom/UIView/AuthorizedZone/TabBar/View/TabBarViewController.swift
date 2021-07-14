//
//  TabBarViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 27.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController, TabBarViewProtocol {
	private var presenter: TabBarPresenter?

	private let childViewController = MusicBarViewController()

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

		setupTabBar()
		configureTabBarAppearance()
		setupChildViewController()
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
				image: UIImage(name: tabBarItem.image),
				selectedImage: UIImage(name: tabBarItem.image)?.withTintColor(.systemPink)
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

		attributes[.foregroundColor] = UIColor.black
		tabBarItem.setTitleTextAttributes(attributes, for: .selected)
	}

	private func configureView() {
		view.backgroundColor = .yellow
		tabBar.barTintColor = .red
		tabBar.tintColor = .green
	}

	private func configureTabBarAppearance() {
		let barAppearance = UITabBar.appearance()
//		barAppearance.shadowImage = UIImage()
//		barAppearance.backgroundImage = UIImage()
//		barAppearance.isTranslucent = false
		barAppearance.unselectedItemTintColor = .white
//		barAppearance.selectedItem?.badgeColor = .clear
	}

	private func setupChildViewController() {
		let viewController = MusicBarViewController()
		add(viewController)

		viewController.view.snp.makeConstraints { make in
//			make.bottom.equalTo(view.snp.top)
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
			make.right.left.equalToSuperview()
			make.height.equalTo(55)
		}
	}

}
