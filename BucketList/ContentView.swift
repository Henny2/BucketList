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
    @State private var selectedPlace: Location?
    
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition){
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate){
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                        // adding a different gesture for selecting of an annotation to avoid confusion for the map 
                            .onLongPressGesture {
                                selectedPlace = location
                            }
                    }
                }
            }
                .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    print("Tapped at \(coordinate)")
                    
                    let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitute: coordinate.longitude)
                    locations.append(newLocation)
                }
            }
            // previously we used this version of sheet
//                .sheet(isPresented: , content: {
//
//                })
            // now we use this one, that can work with Optionals and unwraps them for us automatically, it will only be shown when there is a value inside
                .sheet(item: $selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        // finding the selected place in the locations array and overwriting it with the edited/new location
                        if let index = locations.firstIndex(of: place){
                            locations[index] = newLocation
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
