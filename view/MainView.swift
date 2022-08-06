//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
//let activity = Activity(name: "Test", description: "test this out", participantsLimit: 4, createdAt: "2 august", uid: "wjsnfeuhwjiaodiwedhijkwjd", active: true, hostId: "dksjhcidojwak")
struct MainView: View {
    var body: some View {
        if(Authentication.shared.isLoggedIn()) {
//            Room(activity: activity, userId: "media", token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjJkZDAzOTdjMTY2NDAwNjU2OTViZWY0Iiwicm9vbV9pZCI6IjYyZGQwNmQzYzE2NjQwMDY1Njk1YmYwNSIsInVzZXJfaWQiOiJjZnFsZ2RmbiIsInJvbGUiOiJob3N0IiwianRpIjoiMGQ5NmJlMDctYWJhZi00MWRhLTgxODgtNzUwODQ2M2IyMmY0IiwidHlwZSI6ImFwcCIsInZlcnNpb24iOjIsImV4cCI6MTY1OTYxOTUxN30.EK5BB68Q7d-VjqIb1ewnLXEwMcZs-G6OPyt4ykWMFjQ")
            TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .navigationTitle("Home")
                    SearchView()
                    .tabItem {
                        Label("search", systemImage: "magnifyingglass")
                    }
                    PostActivityView()
                        .tabItem {
                            Label("Post", systemImage: "plus.circle")
                                .font(.largeTitle)
                        }
                      
                    ChatListView()
                    .tabItem {
                        Label("chat", systemImage: "message.fill")
                    }
                ProfileView(showBackButton: false)
                    .tabItem {
                        Label("profile", systemImage: "person.fill")
                    }


            }
            .accentColor(Color("accent"))
            .font(.largeTitle)
            .ignoresSafeArea()
          

        } else {
            RegisterView()
        }
//
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
