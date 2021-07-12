//
//  AppDelegate.swift
//  MusicRoom
//
//  Created by 18588255 on 10.12.2020.
//  Copyright © 2020 School21. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		setupRootViewController()

		// Firebase initial setup
		FirebaseConfiguration.shared.setLoggerLevel(.min)
		FirebaseApp.configure()

		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self

//		// Facebook login stuff
//		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url)
	}

	// MARK: Private

	private func setupRootViewController() {
		let startViewController = StartViewController()
		let navigationController = UINavigationController(rootViewController: startViewController)
		navigationController.modalPresentationStyle = .fullScreen
		navigationController.navigationBar.barTintColor = .clear
		navigationController.navigationBar.tintColor = .white
		navigationController.navigationBar.barStyle = .black

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	// MARK: - GIDSignInDelegate

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		guard error != nil else {
			window?.rootViewController?.showBasicAlert(message: error.debugDescription)
			return
		}

		guard let user = user, let authentication = user.authentication else { return }

		let credential = GoogleAuthProvider.credential(
			withIDToken: authentication.idToken,
			accessToken: authentication.accessToken
		)

		Auth.auth().signIn(with: credential) { [weak self] authResult, error in
			guard let self = self else { return }

			guard let presentingView = self.window?.rootViewController as? LogViewController else { return }

			presentingView.loginWithGoogle()
		}
	}
}

extension UIApplication {
	class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		if let musicBarVC = controller as? MusicBarViewController {
			return topViewController(controller: musicBarVC.embeddedViewController)
		} else if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		} else if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
			return topViewController(controller: selected)
		} else if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		} else {
			return controller
		}
	}
}

