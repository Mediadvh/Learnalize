//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        if(Authentication.shared.isLoggedIn()) {
            TabView {
                
            
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .navigationTitle("Home")
                
                
           
                    PostActivityView()
                        .tabItem {
                            Label("Post", systemImage: "plus.circle")
                                .font(.largeTitle)
                        }
                        .navigationTitle("New Activity")
                
                
           
                    SearchView()
                        .tabItem {
                            Label("search", systemImage: "magnifyingglass")
                        }
                    .navigationTitle("Profile")
                
            }
            .accentColor(Color("accent"))
            .font(.largeTitle)
            .ignoresSafeArea()
            
        } else {
            RegisterView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
