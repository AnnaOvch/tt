//
//  LocationViewModel.swift
//  TestTask
//
//  Created by Anna Ovchynnykova on 18.10.2022.
//

import SwiftUI
import MapKit

protocol LocationViewModelProtocol: ObservableObject {
    var locations: [Location] { get }
    var region: MKCoordinateRegion { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestPermission()
}

class LocationViewModel: NSObject, CLLocationManagerDelegate, LocationViewModelProtocol {
    @Published var authorizationStatus: CLAuthorizationStatus 
    @Published var region: MKCoordinateRegion
    @Published var locations: [Location] = []
    
    private var locationManager: CLLocationManager?
    
    override init() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
        }
        region = MKCoordinateRegion()
        authorizationStatus = locationManager?.authorizationStatus ?? .notDetermined
        super.init()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    func findLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hospital"
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let response = response, let self = self  else {
                return
            }
            self.locations = response.mapItems.map { Location(coordinate: $0.placemark.coordinate) }
        }
    }

    func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.first.map {
            region = MKCoordinateRegion(
                center: $0.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        findLocations()
        locationManager?.stopUpdatingLocation()
    }
}
