//
//  LocationSrevice.swift
//  Runner
//
//  Created by TMS on 11/12/2023.
//

import Foundation
import CoreLocation
import Flutter
import BackgroundTasks

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    static var isTrackingOn : Bool = false;

    private var locationManager: CLLocationManager

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    // MARK: - Public Methods

    func startLocationService()  {
        LocationService.shared.hasLocationAlwaysPermission{
            hasPermission in
            if(hasPermission){
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.showsBackgroundLocationIndicator = true
                self.locationManager.startUpdatingLocation()
            }
            else{
                self.requestForAlwaysLocationPermission()
            }
        }
        LocationService.isTrackingOn = true;
        // BackgroundTaskManager.shared.scheduleAppProcessing()
    }
    
    
    func setupLocationServiceOnAppRelaunch()  {
        LocationService.shared.hasLocationAlwaysPermission{
            hasPermission in
            if(hasPermission){
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.showsBackgroundLocationIndicator = true
                self.locationManager.startMonitoringSignificantLocationChanges()
            }
            else{
                self.requestForAlwaysLocationPermission()
            }
        }
        LocationService.isTrackingOn = true;
    }

    func stopLocationService() {
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.stopUpdatingLocation()
        LocationService.isTrackingOn = false;
        ClockInOutSession.clearSession()
        GeofenceService.shared.stopMonitoringGeofence()
    }
    
    func appEnterBackground(){
        if(LocationService.isTrackingOn){
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func appEnterForeground(){
        if(LocationService.isTrackingOn){
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }

    func isServiceRunning() -> Bool {
        return locationManager.allowsBackgroundLocationUpdates
    }

    func hasLocationAlwaysPermission(completion : @escaping (Bool) -> Void)  {
        DispatchQueue.global().async {
            let result = CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() == .authorizedAlways
            
            //
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func requestForAlwaysLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         // Handle new location data here
        if let location = locations.last {
            
            let locationAge = abs(location.timestamp.timeIntervalSinceNow)
            
            if(locationAge > 30 || location.horizontalAccuracy < 0){
                return
            }
            
          let latitude = location.coordinate.latitude
          let longitude = location.coordinate.longitude
            
            GeofenceService.shared.startMonitoringGeofence(at: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),fromLocationService: true)
            
          let locationData: [String: Any] = ["latitude": latitude, "longitude": longitude, "speed" : location.speed , "heading" : location.course]
            do{
                LocationChannel.channel?.invokeMethod("onLocationUpdate", arguments: locationData)
            }
            catch(_){
                
            }
            do{
                FirebaseLocationLogUpdater().updateLocationInFirebase( location: location)
            }
            catch(_){
                
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status changes, e.g., request permission if needed
        switch status {
        case .authorizedAlways:
            // The user has granted "Always" location access
            // Start or continue location updates as needed
            break
        case .authorizedWhenInUse:
            // The user has granted "When In Use" location access
            // Start or continue location updates as needed
            break
        case .denied, .restricted:
            // The user has denied or restricted location access
            // Handle this situation, prompt the user to change settings, etc.
            break
        case .notDetermined:
            // Location permission has not been requested yet.
            // Do NOT auto-request here: this delegate fires as soon as the
            // CLLocationManager is created (e.g. when stopLocationService is
            // called for an off-shift user), which used to pop the system
            // location prompt at random moments. Permission is requested
            // explicitly via startLocationService /
            // requestForAlwaysLocationPermission or from the Flutter side.
            break
        default:
            break
        }
    }
    
}
