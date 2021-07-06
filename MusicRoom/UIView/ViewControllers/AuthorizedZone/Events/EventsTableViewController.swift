//
//  EventsTableViewController.swift
//  MusicRoom
//
//  Created by 18588255 on 12.01.2021.
//  Copyright © 2021 School21. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAnalytics

enum EventType {
	case `private`
	case `public`
}

final class EventsTableViewController: UITableViewController, CLLocationManagerDelegate {

	var privateEvents: [(uid: String, name: String)]? {
		didSet {
			tableView.reloadData()
		}
	}
	var publicEvents: [(uid: String, name: String)]? {
		didSet {
			tableView.reloadData()
		}
	}
	var allPublicEvents: [Event]? {
		didSet {
			tableView.reloadData()
		}
	}

	var userRef: DatabaseReference?
	var userHandle: UInt?

	var publicEventsRef: DatabaseReference?
	var publicEventsHandle: UInt?

	let locationManager = CLLocationManager()
	var lastKnownLocation: CLLocation?

	// MARK: Initializzation

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Event"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))

		if let userId = Auth.auth().currentUser?.uid {
			userRef = Database.database().reference(withPath: "users/" + userId)
		}

		publicEventsRef = Database.database().reference(withPath: "events/public")

		configureTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		configureDatabase()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if CLLocationManager.locationServicesEnabled() {
			locationManager.stopUpdatingLocation()
		}

		if let handle = userHandle {
			userRef?.removeObserver(withHandle: handle)
		}
		if let handle = publicEventsHandle {
			publicEventsRef?.removeObserver(withHandle: handle)
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			if let count = privateEvents?.count, count > 0 {
				return count
			}
			return 1

		case 1:
			if let count = allPublicEvents?.count, count > 0 {
				return count
			}
			return 1

		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Private Events"

		case 1:
			return "Public Events"

		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
		var title = ""

		switch indexPath.section {
		case 0:
			if privateEvents?.isEmpty != false {
				title += "No private events yet..."
//				cell.isUserInteractionEnabled = false
			} else {
//				cell.isUserInteractionEnabled = true
			}
			title += privateEvents?[safe: indexPath.row]?.name ?? ""

		case 1:
			if allPublicEvents?.isEmpty != false {
				title += "No public events yet..."
//				cell.isUserInteractionEnabled = false
			} else {
//				cell.isUserInteractionEnabled = true
			}
			title += allPublicEvents?[safe: indexPath.row]?.name ?? ""

		default:
			break
		}

		cell.textLabel?.text = title
		return cell
	}


	// MARK: - TableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let events = eventsForSection(indexPath: indexPath), events.count > 0 {
			let metadata = events[indexPath.row]
			let eventType: EventType = indexPath.section == 0 ? .private : .public

			let viewController = ShowEventViewController(eventUid: metadata.uid, eventName: metadata.name, eventType: eventType)
			let navigationController = UINavigationController(rootViewController: viewController)
			present(navigationController, animated: true)
		}
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if let events = eventsForSection(indexPath: indexPath) {
			return events.count > 0
		}

		return false
	}

	override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		locationManager.stopUpdatingLocation()
	}

	override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		locationManager.startUpdatingLocation()
	}

	/// !!!!!!!!!!!!
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			if indexPath.section == 0, let privateEvents = privateEvents {
				let eventId = privateEvents[indexPath.row].uid
				let privateRef = Database.database().reference(withPath: "events/private")

				privateRef.child(eventId).observeSingleEvent(of: .value, with: { snapshot in

					let playlist = Playlist(snapshot: snapshot)
					if playlist.createdBy != Auth.auth().currentUser?.uid {
						tableView.setEditing(false, animated: true)

						self.showBasicAlert(title: "You can't delete this event", message: "This event is not yours.")
					} else {


						var removeModifications: [AnyHashable: Any] = [
							"events/private/\(eventId)": NSNull()
						]

						if let userIds = playlist.userIds {
							for user in userIds {
								removeModifications["users/\(user.key)/events/\(eventId)"] = NSNull()
							}
						}

						Database.database().reference().updateChildValues(removeModifications) { error, _ in
							guard error == nil else { return }

							Analytics.logEvent("deleted_event", parameters: Log.defaultInfo())
						}
					}
				})
			} else if indexPath.section == 1, let publicEvents = self.publicEvents, let publicRef = publicEventsRef {
				publicRef.child(publicEvents[indexPath.row].uid).observeSingleEvent(of: .value, with: { snapshot in
					let eventId = publicEvents[indexPath.row].uid

					let playlist = Playlist(snapshot: snapshot)
					if playlist.createdBy != Auth.auth().currentUser?.uid {
						tableView.setEditing(false, animated: true)

						self.showBasicAlert(title: "You can't delete this event", message: "This event is not yours.")
					} else {
						publicRef.child(eventId).removeValue() { error, _ in
							guard error == nil else { return }

							Analytics.logEvent("deleted_event", parameters: Log.defaultInfo())
						}
					}
				})
			}
		}

	}

	// MARK: - Private

	private func configureTableView() {
		tableView.registerReusable(cellClass: UITableViewCell.self)
	}

	private func refilterPublicEvents() {
		var events: [(uid: String, name: String)] = []
		if let allevents = allPublicEvents {
			for event in allevents {
				if let uid = event.uid, let name = event.name {
					events.append((uid: uid, name: name))
				}
			}
		}
		publicEvents = events
		guard let lastKnownLocation = lastKnownLocation else { return self.publicEvents = nil }

		let goodToShow = allPublicEvents?.filter { event in
			if Auth.auth().currentUser?.uid == event.createdBy {
				return true
			}
			return event.closeEnough(to: lastKnownLocation) && event.timeRange()
		}

		self.publicEvents = goodToShow?.map { event in
			if let uid = event.uid, let name = event.name {
				return (uid: uid, name: name)
			}
			return (uid: "", name: "Name failed to load")
		}

		self.tableView.reloadData()
	}

	private func eventsForSection(indexPath: IndexPath) -> [(uid: String, name: String)]? {
		switch indexPath.section {
		case 0:
			return privateEvents

		case 1:
			return publicEvents

		default:
			return nil
		}
	}

	private func configureDatabase() {

		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
				case .notDetermined:
					self.locationManager.requestWhenInUseAuthorization()
				case .denied:
					self.showLocationAlert()
				default: break
			}

			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}


		userHandle = userRef?.observe(.value, with: { snapshot in
			let user = User(snapshot: snapshot)

			self.privateEvents = user.events?.map { element in (uid: element.key, name: element.value) }
			if self.privateEvents == nil {
				self.privateEvents = []
			}

			self.tableView.reloadData()
		})

		self.publicEventsHandle = self.publicEventsRef?.observe(.value, with: { snapshot in
			var events = [Event]()

			for snap in snapshot.children {
				if let snap = snap as? DataSnapshot {
					let event = Event(snapshot: snap)
					events.append(event)
				}
			}

			self.allPublicEvents = events

			var someEvents: [(uid: String, name: String)] = []
			if let allevents = self.allPublicEvents {
					for event in allevents {
						if let uid = event.uid, let name = event.name {
							someEvents.append((uid: uid, name: name))
						}
					}
				}
			self.publicEvents = someEvents

//			self.refilterPublicEvents()
		})


	}

	// MARK: - Actions

	@objc func addEvent() {
		let viewController = AddEventsTableViewController()
		let navigationController = UINavigationController(rootViewController: viewController)
		present(navigationController, animated: true)
	}

	// MARK: - CLLocationManagerDelegate

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		lastKnownLocation = locations.first

		refilterPublicEvents()
	}

}
