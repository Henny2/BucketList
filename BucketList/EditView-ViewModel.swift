//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/13/24.
//

import Foundation
import SwiftUI

// advice https://www.hackingwithswift.com/forums/100-days-of-swiftui/day-73-project-14-advice-on-third-challenge-editview-modelview/13200

extension EditView {
    @Observable
    class ViewModel {
        enum loadingStates {
            case loading, loaded, failed
        }
        var loadingState = loadingStates.loading
        var location: Location
        var name: String
        var description: String
        var pages = [Page]()
        
        init(location: Location){
            self.location = location
            name = location.name
            description =  location.description
        }
    }
}
