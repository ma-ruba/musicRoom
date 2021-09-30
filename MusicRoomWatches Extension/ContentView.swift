//
//  ContentView.swift
//  MusicRoomWatches Extension
//
//  Created by Mariia on 30.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@Binding var model: MusicRoomWatchModel

	var body: some View {
		switch model.appState {
		case .enabled:
			TrackView(trackModel: $model.trackViewModel)

		case .disabled:
			Text(LocalizedStrings.Watch.noConnection.localized)
		}
	}
}
