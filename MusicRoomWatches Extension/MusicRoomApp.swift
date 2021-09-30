//
//  MusicRoomApp.swift
//  MusicRoomWatches Extension
//
//  Created by 18588255 on 30.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import SwiftUI

@main
struct MusicRoomApp: App {
	@ObservedObject var model = WatchConnectivityManager.shared

	@SceneBuilder var body: some Scene {
		WindowGroup {
			NavigationView {
				ContentView(model: $model.appModel)
			}
		}

		WKNotificationScene(controller: NotificationController.self, category: "myCategory")
	}
}
