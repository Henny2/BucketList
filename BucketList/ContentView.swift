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
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition){
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate){
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                            // adding a different gesture for selecting of an annotation to avoid confusion for the map
                                .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                // previously we used this version of sheet
                //                .sheet(isPresented: , content: {
                //
                //                })
                // now we use this one, that can work with Optionals and unwraps them for us automatically, it will only be shown when there is a value inside
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        // finding the selected place in the locations array and overwriting it with the edited/new location
                        viewModel.update(location: newLocation)
                        
                    }
                }
            }
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
