//
//  MapTableViewCell.swift
//  MusicRoom
//
//  Created by 18588255 on 13.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit
import MapKit

final class MapTableViewCell: UITableViewCell {

	let label = UILabel()
	let mapView = MKMapView()
	let markerImage = UIImageView()
	let button = UIButton()

	// MARK: Initializzation

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupUI()
		configureUI()
	}

	required init?(coder: NSCoder) {
		assertionFailure("init(coder:) has not been implemented")
		return nil
	}

	// MARK: - Private

	// MARK: Setup

	private func setupUI() {
		setupMap()
		setupLabel()
		setupMarkerImage()
		setupButton()
	}

	private func setupMap() {
		contentView.addSubview(mapView)

		mapView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.height.equalTo(300)
		}
	}

	private func setupLabel() {
		contentView.addSubview(label)

		label.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	private func setupMarkerImage() {
		contentView.addSubview(markerImage)

		markerImage.snp.makeConstraints { make in
			make.size.equalTo(20)
			make.center.equalToSuperview()
		}
	}

	private func setupButton() {
		contentView.addSubview(button)

		button.snp.makeConstraints { make in
			make.size.equalTo(30)
			make.bottom.right.equalToSuperview()
		}
	}

	// MARK: Configuration

	private func configureUI() {
		configureMap()
		configureLabel()
		configureMarkerImage()
		configureButton()
	}

	private func configureMap() {
		mapView.isHidden = true
	}

	private func configureLabel() {
		label.text = "Anywhere"
		label.font = .systemFont(ofSize: 24, weight: .bold)
	}

	private func configureMarkerImage() {
		markerImage.image = UIImage(name: .marker)
	}

	private func configureButton() {
		button.setImage(UIImage(name: .location), for: .normal)
	}

}
