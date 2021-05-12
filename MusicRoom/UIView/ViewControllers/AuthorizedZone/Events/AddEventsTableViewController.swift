//
//  AddEventsTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit
import MapKit

final class AddEventsTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	var locationFollowsUser = true

	let locationManager = CLLocationManager()

	let radiusMinimum = Float(100)
	let radiusMaximum = Float(1000)
	let sliderToRadiusPow = Float(8.0)
	var radiusMeters: Int?

	var startScroll = UIDatePicker()
	var endScroll = UIDatePicker()
	var publicSwitch = UISwitch()
	var slider = UISlider()
	var timeSwitch = UISwitch()
	var distanceSwitch = UISwitch()
	var nameLabel = UITextField()
	var map = MKMapView()
	var mapButton = UIButton()
	var mapLabel = UILabel()
	var mapImage = UIImageView()
	var distanseLabel = UILabel()

	// MARK: Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureCoordinates()
		configureTableView()

		navigationItem.title = "Create event"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if CLLocationManager.locationServicesEnabled() {
			locationManager.stopUpdatingLocation()
		}
	}

	// MARK: Private

	private func setRadius() {
		let meters = pow(slider.value, sliderToRadiusPow) * radiusMinimum
		var metersString = String(format:"%.0f", meters)

		if metersString.count > 2 {
			let firstTwo = metersString.substring(to: metersString.index(metersString.startIndex, offsetBy: 2))

			metersString = firstTwo + String(repeating: "0", count: metersString.count - 2)
		}

		radiusMeters = Int(metersString)

		if let parsedInt = radiusMeters  {
			if parsedInt >= 1000 {
				distanseLabel.text = String(format: "%.1f", Float(parsedInt) / 1000) + " km"
			} else {
				distanseLabel.text = "\(parsedInt) meters"
			}
			setCircle()
		} else {
			distanseLabel.text = "Error"
		}

	}

	private func configureTableView() {
		tableView.registerReusable(cellClass: SwitchTableViewCell.self)
		tableView.registerReusable(cellClass: MapTableViewCell.self)
		tableView.registerReusable(cellClass: TextFieldTableViewCell.self)
		tableView.registerReusable(cellClass: ScrollTableViewCell.self)
		tableView.registerReusable(cellClass: SliderTableViewCell.self)

		tableView.backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
	}

	private func configureCoordinates() {
		if CLLocationManager.locationServicesEnabled() {
			self.locationManager.requestWhenInUseAuthorization()
			self.locationManager.delegate = self
			self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			self.locationManager.startUpdatingLocation()
		}
	}

	private func setCircle() {
		map.removeOverlays(map.overlays)
		if let radius = radiusMeters {
			map.addOverlay(MKCircle(center: map.centerCoordinate, radius: CLLocationDistance(radius)))
		}
	}

	// MARK: MapKit

	func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
		if let gestureRecognizers = map.subviews[0].gestureRecognizers {
			for recognizer in gestureRecognizers {
				if (recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
					locationFollowsUser = false
					mapButton.isHidden = false

					return
				}
			}
		}
	}

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		setCircle()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if distanceSwitch.isOn, locationFollowsUser, let location = locations.last {
			let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

			map.setRegion(region, animated: true)
		}
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let overlay = overlay as? MKCircle {
			let circleRenderer = MKCircleRenderer(circle: overlay)
			circleRenderer.fillColor = UIColor.black.withAlphaComponent(0.5)
			circleRenderer.strokeColor = UIColor.blue
			circleRenderer.lineWidth = 1
			return circleRenderer
		}
		return MKOverlayRenderer()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 2:
			return 2

		default:
			return 3
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Basic Info"

		case 1:
			return "Date"

		case 2:
			return "Location"

		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear

		return view
	}

	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear

		return view
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 46
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withClass: TextFieldTableViewCell.self, for: indexPath)
				cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
				cell.layer.cornerRadius = 12
				nameLabel = cell.textField
				return cell

			default:
				let cell = tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)
				cell.label.text = "Public"
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				publicSwitch = cell.switchItem
				return cell
			}

		case 1:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)
				cell.switchItem.addTarget(self, action: #selector(dateSwitcherChanged(sender:)), for: .touchUpInside)
				cell.label.text = "Specific time"
				cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
				cell.layer.cornerRadius = 12
				timeSwitch = cell.switchItem
				return cell

			case 1:
				let cell = tableView.dequeueReusableCell(withClass: ScrollTableViewCell.self, for: indexPath)
				cell.label.text = "Start"
				cell.scroll.minimumDate = Date()
				startScroll = cell.scroll
				return cell

			default:
				let cell = tableView.dequeueReusableCell(withClass: ScrollTableViewCell.self, for: indexPath)
				cell.label.text = "End"
				var components = DateComponents()
				components.setValue(1, for: .hour)
				cell.scroll.minimumDate = Calendar.current.date(byAdding: components, to: Date())
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				endScroll = cell.scroll
				return cell
			}

		case 2:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withClass: SwitchTableViewCell.self, for: indexPath)
				cell.switchItem.addTarget(self, action: #selector(locationcSwitcherChanged), for: .touchUpInside)
				cell.label.text = "Specific location"
				cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
				cell.layer.cornerRadius = 12
				distanceSwitch = cell.switchItem
				locationcSwitcherChanged()
				return cell

			case 1:
				let cell = tableView.dequeueReusableCell(withClass: SliderTableViewCell.self, for: indexPath)
				cell.mainLabel.text = "Event radius"
				cell.slider.minimumValue = 1
				cell.slider.maximumValue = pow(radiusMaximum / radiusMinimum, Float(1.0 / sliderToRadiusPow))
				cell.slider.value = pow(100 / radiusMinimum, Float(1.0 / sliderToRadiusPow))
				cell.slider.addTarget(self, action: #selector(radiusChanged), for: .touchUpInside)
				setRadius()
				slider = cell.slider
				distanseLabel = cell.distanseLabel
				return cell

			default:
				let cell = tableView.dequeueReusableCell(withClass: MapTableViewCell.self, for: indexPath)
				cell.backgroundView = MKMapView()
				cell.button.addTarget(self, action: #selector(followed), for: .touchUpInside)
				cell.layer.cornerRadius = 12
				cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				map = cell.mapView
				mapButton = cell.button
				mapLabel = cell.label
				mapImage = cell.markerImage
				return cell
			}

		default:
			return UITableViewCell()
		}
	}

	// MARK: - Actions

	@objc private func radiusChanged() {
		setRadius()
	}

	@objc private func dateSwitcherChanged(sender: Any) {
		if timeSwitch.isOn {
			startScroll.isEnabled = true
			endScroll.isEnabled = true
		} else {
			startScroll.isEnabled = false
			endScroll.isEnabled = false
		}
	}

	@objc private func locationcSwitcherChanged() {
		if distanceSwitch.isOn {
			setRadius()
			slider.isEnabled = true

			map.isZoomEnabled = true
			map.isScrollEnabled = true
			map.isUserInteractionEnabled = true

			mapImage.isHidden = false
			mapLabel.isHidden = true
			map.showsUserLocation = true
		} else {
			map.removeOverlays(map.overlays)
			distanseLabel.text = "Infinite"
			slider.isEnabled = false

			map.isZoomEnabled = false
			map.isScrollEnabled = false
			map.isUserInteractionEnabled = false

			mapImage.isHidden = true
			mapLabel.isHidden = false
			map.showsUserLocation = false
		}
	}


	@objc private func goBack() {
		dismiss(animated: true, completion: nil)
	}

	@objc private func followed() {
		map.centerCoordinate = map.userLocation.coordinate
		locationFollowsUser = true
		mapButton.isHidden = true
	}

	@objc private func done() {
		guard let userId = Auth.auth().currentUser?.uid, let eventName = nameLabel.text, !eventName.isEmpty else {
			return showBasicAlert(message: "Name field is compulsary!")
		}

		var newEvent = Event(name: eventName, createdBy: userId)

		if !publicSwitch.isOn {
			newEvent.userIds = [userId: true]
		}

		if timeSwitch.isOn {
			guard startScroll.date < endScroll.date else {
				return showBasicAlert(message: "The end date must be after the start date.")
			}

			newEvent.startDate = UInt(startScroll.date.timeIntervalSince1970)
			newEvent.endDate = UInt(endScroll.date.timeIntervalSince1970)
		}

		if distanceSwitch.isOn {
			guard let radius = self.radiusMeters else {
				return showBasicAlert(message: "You have to specify location")
			}

			newEvent.radius = radius
			newEvent.latitude = map.centerCoordinate.latitude
			newEvent.longitude = map.centerCoordinate.longitude
		}

		let eventsPath = "events/" + (publicSwitch.isOn ? "public" : "private")
		let eventRef = Database.database().reference(withPath: eventsPath)
		let newEventRef = eventRef.childByAutoId()

		if publicSwitch.isOn {
			newEventRef.setValue(newEvent.toDict()) { error, _ in
				guard error == nil else { return }

				Analytics.logEvent("created_event", parameters: Log.defaultInfo())
			}
		} else {
			let newPrivateEventRef : [String:Any] = ["users/\(userId)/events/\(newEventRef.key)": eventName, "events/private/\(newEventRef.key)": newEvent.toDict()]
			let ref = Database.database().reference()
			ref.updateChildValues(newPrivateEventRef, withCompletionBlock: { (error, ref) -> Void in
				Analytics.logEvent("created_event", parameters: Log.defaultInfo())
			})
		}

		dismiss(animated: true, completion: nil)
	}
}
