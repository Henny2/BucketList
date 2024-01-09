//
//  ContentView.swift
//  BucketList
//
//  Created by Henrieke Baunack on 12/31/23.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var locations = [Location]()
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition){
                ForEach(locations) { location in
                    Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitute))
                }
            }
                .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    print("Tapped at \(coordinate)")
                    
                    let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitute: coordinate.longitude)
                    locations.append(newLocation)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
