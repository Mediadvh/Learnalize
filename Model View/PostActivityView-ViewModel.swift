//
//  PostActivityView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
extension PostActivityView {
    @MainActor class ModelView: ObservableObject {
        @Published var activityInput = ""
        @Published var descriptionInput = ""
    }
}
