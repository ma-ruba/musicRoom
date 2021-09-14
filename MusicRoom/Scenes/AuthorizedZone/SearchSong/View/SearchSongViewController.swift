//
//  SearchSongViewController.swift
//  MusicRoom
//
//  Created by Mariia on 15.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class SearchSongViewController:
	UIViewController,
	SearchSongViewProtocol,
	UITableViewDelegate,
	UITableViewDataSource,
	UISearchResultsUpdating
{
	private var presenter: SearchSongPresenterProtocol?

	private lazy var tableView = UITableView()
	private lazy var searchController = UISearchController(searchResultsController: nil)

	// MARK: Initialization

	init(with inputModel: Playlist) {

		super.init(nibName: nil, bundle: nil)

		presenter = SearchSongPresenter(view: self, inputModel: inputModel)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		configureUI()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		definesPresentationContext = false
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupTableView()
	}

	private func setupTableView() {
		view.addSubview(tableView)

		tableView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(GlobalConstants.musicBarHeight)
		}
	}

	// MARK: Configure

	private func configureNavigationItem() {
		navigationItem.title = LocalizedStrings.SearchSong.navigationTitle.localized
	}

	private func configureUI() {
		configureTableView()
		configureSearchController()
	}

	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 64
		tableView.registerReusable(cellClass: LabelsTableViewCell.self)
		tableView.tableHeaderView = searchController.searchBar
	}

	private func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		definesPresentationContext = true
		searchController.searchBar.placeholder = LocalizedStrings.SearchSong.searchPlaceholder.localized
	}

	// MARK: - UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfRows ?? 0
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return presenter?.numberOfSections ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withClass: LabelsTableViewCell.self, for: indexPath)
		guard let model = presenter?.getCellModel(at: indexPath.row) else { return cell }
		cell.configure(with: model)

		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.addNewTrack(at: indexPath.row)
	}

	// MARK: - UISearchResultsUpdating

	public func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text else { return }

		presenter?.filterContentForSearchText(searchText: searchText)
	}

	// MARK: - SearchSongViewProtocol

	func reloadTableView() {
		tableView.reloadData()
	}
	
	func reloadCellForRow(at index: Int) {
		guard let numberOfRows = presenter?.numberOfRows, index < numberOfRows else { return }
		
		tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
	}
}
