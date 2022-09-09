//
//  HomeView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI




struct HomeView: View {
    
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
            Color("background")
                VStack {
                    HStack {
                        Text("Learnalize")
                        .font(.largeTitle)
                        .padding()
                        .navigationBarHidden(true)
                        Spacer()
                        
                    }
                    if let activities = viewModel.activities {
                        activityList(activities: activities, isAbleToJoin: true, showsUsername: true)
                            .refreshable {
                                viewModel.refreshFeed()
                            }
                      
                        
                    } else if viewModel.isLoading {
                        LoadingView(color: Colors.background)
                    } else {
                        Text("no activities, follow more people!")
                    }
                  
                 
                }
              
        }
      
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("accent"))
            .navigationBarHidden(true)
            
        }
        
        
    }
    
    // MARK: UIElements
    var profileButton: some View {
        Image(systemName: "person.fill")
            .font(.largeTitle)
            .padding()
    }
    
    
    

}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
