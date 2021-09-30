//
//  PlayButton.swift
//  MusicRoomWatch Extension
//
//  Created by 18588255 on 21.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import SwiftUI

private enum Constants {
	static let lineWidth: CGFloat = 4
}

struct PlayButton: View {
	@Binding var model: PlayButtonModel

	var body: some View {
		ZStack {
			Circle()
				.stroke(Color.gray, lineWidth: Constants.lineWidth)
				.opacity(0.3)

			Circle()
				.trim(from: 0.0, to: CGFloat(min(model.progress, 1.0)))
				.stroke(
					Color.gray,
					style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round, lineJoin: .round)
				)
				.animation(.linear)
				.rotationEffect(Angle(degrees: 270.0))

			Image(systemName: model.imageName)
				.foregroundColor(.gray)
		}
	}
}
