//
//  SearchView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI


struct SearchView: View {
    @StateObject var viewModel = ViewModel()
    @State var mode = 0
    var body: some View {
        NavigationView {
            VStack {
                segmentedPicker
                    .padding()
                    
                searchBar
                    .font(.body)
                resultView
                Spacer(minLength: 0)
                
            }
           
           
        }
    }
    var segmentedPicker: some View {
        Picker("Search Mode", selection: $viewModel.mode) {
            Text("User").tag(SearchMode.searchUser)
            Text("Activity").tag(SearchMode.searchActivity)
        }.pickerStyle(.segmented)
    }
    var searchBar: some View {
        SearchBar(placeholder: "Search", text: $viewModel.text)
            .onSubmit({
                viewModel.isLoading = true
                if viewModel.mode == .searchActivity {
                    viewModel.searchActivity(name: viewModel.text)
                } else {
                    viewModel.searchUser(username: viewModel.text)
                }
                
            })
            .padding()
   }
    var resultView: some View {
        VStack {
            
            
            if viewModel.isLoading {
                LoadingView(color: Colors.background)
            } else if viewModel.mode == .searchActivity && viewModel.foundResult == true {
                   activityList(activities: viewModel.resultActivities, isAbleToJoin: true, showsUsername: true)
            } else if viewModel.mode == .searchUser && viewModel.foundResult == true {
                UserResultView(users: viewModel.resultUsers,  destination: .profileView)
                
            } else if viewModel.foundResult == false && viewModel.isLoading == false{
                Spacer()
                Text("results not found!")
                Spacer()
            }
            
        }.navigationBarHidden(true)
            .font(.body)
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        SearchView()
            .preferredColorScheme(.dark)
    }
}
