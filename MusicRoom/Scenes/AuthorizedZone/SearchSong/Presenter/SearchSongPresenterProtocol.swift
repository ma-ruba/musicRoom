//
//  SearchSongPresenterProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for SearchSongPresenter.
protocol SearchSongPresenterProtocol {

	/// Property that describes number of sections in the tableView in SearchSongView.
	var numberOfSections: Int { get }

	/// Property that describes number of rows in the tableView in SearchSongView.
	var numberOfRows: Int { get }

	/// Method configures SearchSongModel.
	func configureModel(with inputModel: Playlist)

	/// Method adds a new track to the track list.
	func addNewTrack(at index: Int)

	/// Method  performs a search on the query.
	func filterContentForSearchText(searchText: String)

	/// Method gets a track at certain index.
	func getTrack(at index: Int) -> Track?
}
