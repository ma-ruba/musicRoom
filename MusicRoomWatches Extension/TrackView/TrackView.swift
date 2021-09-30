//
//  TrackView.swift
//  MusicRoomWatch Extension
//
//  Created by 18588255 on 27.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import SwiftUI

struct TrackView: View {
	@Binding var trackModel: TrackViewModel

	var body: some View {
		if trackModel.buttonModel.state == .disabled {
			Text(LocalizedStrings.Watch.nothingIsPlaying.localized)
		} else {
			VStack {
				Text(trackModel.trackName)

				Spacer()

				PlayButton(model: $trackModel.buttonModel)
					.frame(width: 100, height: 100, alignment: .center)
					.onTapGesture {
						trackModel.buttonModel.state.toggle()
						trackModel.buttonModel.action()
					}
			}
		}
	}
}
