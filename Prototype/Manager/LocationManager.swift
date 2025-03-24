//
//  LocationManager.swift
//  Prototype
//
//  Created by 최낙주 on 3/17/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared: LocationManager = .init()
    @Published var address: Address
    var userLocation: CLLocation = CLLocation()
    
    lazy var manager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private var isUpdatingLocation: Bool = false
    
    init(
        address: Address = .init(
            latitude: 0,
            longitude: 0,
            administrativeArea: "",
            locality: "",
            subLocality: "",
            thoroughfare: "",
            subThoroughfare: ""
        )
    ) {
        self.address = address
    }
    
    private func startUpdatingLocation() {
        guard !isUpdatingLocation else { return }
        isUpdatingLocation = true
        manager.startUpdatingLocation()
    }
    
    func checkLocationAuthorization() {
        manager.delegate = self
        self.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            address.latitude = manager.location?.coordinate.latitude ?? 0
            address.longitude = manager.location?.coordinate.longitude ?? 0
        
        @unknown default:
            print("Location service disabled")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.address.latitude = location.coordinate.latitude
            self.address.longitude = location.coordinate.longitude
        }
    }
    
    func reverseGeocoding(_ latitude: Double, _ longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last else { return }
            DispatchQueue.main.async {
                self.address.administrativeArea = address.administrativeArea ?? ""
                self.address.locality = address.locality ?? ""
                self.address.subLocality = address.subLocality ?? ""
                self.address.thoroughfare = address.thoroughfare ?? ""
                self.address.subThoroughfare = address.subThoroughfare ?? ""
            }
        }
    }
}
