//
//  EditView.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/9/24.
//

import SwiftUI

struct EditView: View {
    
    // states of the fetch request to wikipedia
    enum loadingStates {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    @State private var name: String
    @State private var description: String
    
    var onSave: (Location) -> Void // this means we require a function to be passed in whereever the EditView is used, it accepts a Location and returns nothing bc it is supposed to just save it
    
    @State private var loadingState = loadingStates.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby"){
                    switch loadingState {
                    case .loading:
                        Text("loading...")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text("Page description here").italic()
                        }
                    case .failed:
                        Text("Something went wrong")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save"){
                    var newLocation = location
                    newLocation.id = UUID() // changing the id so that the map refreshes and shows the updates to the name and description
                    // not using our own equatable function would do the trick as well, because it would then check all properties for equality and as the name would be updated, it would see a change and update the map 
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            // loading should happen as soon as view gets shown on screen
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from:url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted {$0.title < $1.title }
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
    
    init(location: Location, onSave: @escaping (Location)-> Void){
        self.location = location
        self.onSave = onSave // mark the function as @escaping because we need to save it for later versus running it right now in the init function
        
        // underscore lets us overwrite the property wrapper, the same way we did that for Query
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

#Preview {
    EditView(location: .example) {_ in}
}
