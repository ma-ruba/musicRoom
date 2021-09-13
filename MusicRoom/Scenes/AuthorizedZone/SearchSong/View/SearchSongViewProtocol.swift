//
//  SearchSongViewProtocol.swift
//  MusicRoom
//
//  Created by Mariia on 27.08.2021.
//  Copyright © 2021 School21. All rights reserved.
//

/// Interface for SearchSongView.
protocol SearchSongViewProtocol: BasicViewProtocol {

	/// Method reloads tableView in SearchSongView.
	func reloadTableView()
	
	/// Method reloads certain row in tableView in SearchSongView.
	func reloadCellForRow(at index: Int)
}
