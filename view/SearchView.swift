//
//  SearchView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI


struct SearchView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
       VStack {
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

           if viewModel.isLoading {
               LoadingView(color: Colors.background)
           } else if viewModel.mode == .searchActivity && viewModel.foundResult == true {
               activityList(isAbleToJoin: true, showsUsername: true, model: viewModel.resultActivities)
           } else if viewModel.mode == .searchUser && viewModel.foundResult == true {
               UserList(users: viewModel.resultUsers)
           } else if viewModel.foundResult == false && viewModel.isLoading == false{
               Spacer()
               Text("results not found!")
               Spacer()
           }
           
         
           
       }
    }
    
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        SearchView()
            .preferredColorScheme(.dark)
    }
}