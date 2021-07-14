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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		setupRootViewController()

		// Firebase initial setup
		FirebaseConfiguration.shared.setLoggerLevel(.min)
		FirebaseApp.configure()

		// Auth with Google setup
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self

		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url)
	}

	// MARK: Private

	private func setupRootViewController() {
		let startViewController = StartViewController()
		let navigationController = CustomNavigationController(rootViewController: startViewController)
		navigationController.setNavigationBarHidden(true, animated: true)

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	// MARK: - GIDSignInDelegate

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		guard error == nil else {
			window?.rootViewController?.showBasicAlert(message: error.localizedDescription)
			return
		}

		guard let user = user, let authentication = user.authentication else { return }

		let credential = GoogleAuthProvider.credential(
			withIDToken: authentication.idToken,
			accessToken: authentication.accessToken
		)

		guard let navigationController = self.window?.rootViewController as? UINavigationController,
			let presentingView = navigationController.visibleViewController as? LogViewController
		else {
			return
		}

		presentingView.showSpinner {
			Auth.auth().signIn(with: credential) { authResult, error in
				presentingView.hideSpinner {
					presentingView.loginWithGoogle()
				}
			}
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

