//
//  EditView.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/9/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    @State private var name: String
    @State private var description: String
    
    var onSave: (Location) -> Void // this means we require a function to be passed in whereever the EditView is used, it accepts a Location and returns nothing bc it is supposed to just save it
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
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
