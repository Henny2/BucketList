//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/11/24.
//
import CoreLocation // to get CLLocationCoordinate2D
import Foundation
import LocalAuthentication
import MapKit
import SwiftUI
// MVVM Architecture strategy
// new class that manages our data on behalf of ContentView
// viewModel for contentview so making it an extension
//
extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations : [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        
        var BiometricsAlerIsShown = false 
        var BiometricsAlertTitle = "There was an issue with FaceID"
        var BiometricsAlertMessage = ""
        
        var isStandardMode : Bool = true
        
        var mapMode : MapStyle {
            if isStandardMode {
                return .standard
            }
            else {
                return .hybrid
            }
        }
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection]) // completeFileProtection for encryption
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location){
            guard let selectedPlace else {return} // checking we have a location selected on the map
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // good to go with biometrics
                let reason = "Please authenticate yourself to unlock your places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.BiometricsAlertMessage = "Try again, your face was not recognized."
                        self.BiometricsAlerIsShown = true
                    }
                }
            } else {
                BiometricsAlertMessage = "Your Phone does not support Face ID :("
                BiometricsAlerIsShown = true
            }
        }
    }
}
