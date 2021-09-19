//
//  PlaylistPresenterTest.swift
//  MusicRoomTests
//
//  Created by 18588255 on 15.09.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import XCTest
import Foundation
@testable import MusicRoom

final class PlaylistPresenterTest: XCTestCase {

	private var playlistPresenter: PlaylistPresenterProtocol!
	private var playlistModel: PlaylistModelMock!

	override func setUp() {
		super.setUp()

		let playlistView = PlaylistViewController()
		let presenter = PlaylistPresenter(view: playlistView)
		playlistModel = PlaylistModelMock()
		presenter.model = playlistModel
		playlistPresenter = presenter

		// Data in model is setting asynchronously, so before testing anything we are waiting for it.
		sleep(1)
	}

	override func tearDown() {
		playlistModel = nil
		playlistPresenter = nil

		super.tearDown()
	}

	func testNumberOfSectionsProperty() {
		// assert
		XCTAssertEqual(PlaylistType.allCases.count, playlistPresenter.numberOfSections)
	}

	func testNumberOfRowsInSection() {
		// arrange
		let section = playlistPresenter.numberOfSections - 1

		// act
		let result = playlistPresenter.numberOfRows(in: section)
		let expectedResult = playlistModel.publicPlaylist.count

		// assert
		XCTAssertEqual(result, expectedResult)
	}


	/// Method tests that if the invalid indexPath is passed nil is returned.
	func testPlaylistForIndexPathFailure() {
		// arrange
		let section = playlistPresenter.numberOfSections - 1
		let row = playlistModel.publicPlaylist.count
		let indexPath = IndexPath(row: row, section: section)

		// act
		let result = playlistPresenter.playlist(for: indexPath)

		// assert
		XCTAssertNil(result)
	}

	/// Method tests that if valid  indexPath is passed correct playlist item  is returned.
	func testPlaylistForIndexPathSuccess() {
		// arrange
		let section = playlistPresenter.numberOfSections - 1
		let row = playlistModel.publicPlaylist.count - 1
		let indexPath = IndexPath(row: row, section: section)

		// act
		let result = playlistPresenter.playlist(for: indexPath)
		let expectedResult = playlistModel.publicPlaylist[safe: row]

		// assert
		XCTAssertEqual(result, expectedResult)
	}

	/// Method tests that if the invalid indexPath is passed nothing happens.
	func testDeletePlaylistAtIndexPathFailure() {
		// arrange
		let section = playlistPresenter.numberOfSections
		let row = playlistModel.publicPlaylist.count
		let indexPath = IndexPath(row: row, section: section)
		let initialResult = playlistModel.privatePlaylist.count

		// act
		playlistPresenter.deletePlaylist(at: indexPath)

		// assert
		XCTAssertEqual(initialResult, playlistModel.privatePlaylist.count)
	}

//	/// Method tests that if the valid indexPath is passed playlist is deleted.
//	func testDeletePlaylistAtIndexPathSuccess() {
//		// arrange
//		let section = 0
//		let row = 0
//		let indexPath = IndexPath(row: row, section: section)
//		let initialResult = playlistModel.privatePlaylist.count
//
//		// act
//		playlistPresenter.deletePlaylist(at: indexPath)
//
//		// assert
//		XCTAssertEqual(initialResult - 1, playlistModel.privatePlaylist.count)
//	}
}
