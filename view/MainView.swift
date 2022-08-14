//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
let activity = Activity(name: "Test", description: "test this out", participantsLimit: 4, createdAt: "2 august", uid: "wjsnfeuhwjiaodiwedhijkwjd", active: true, hostId: "dksjhcidojwak", host: User(fullName: "media", picture: "s", email: "Asasdas", password: "ASdda", username: "Adsd", id: "ad"))
struct MainView: View {
    let isAdmin = true
    var body: some View {
//        if (isAdmin == true) {
//            SearchView()
//        }
//       else
        if(Authentication.shared.isLoggedIn()) {
        
//    Room(activity: activity, userId: "media", token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjJkZDAzOTdjMTY2NDAwNjU2OTViZWY0Iiwicm9vbV9pZCI6IjYyZGQwNmQzYzE2NjQwMDY1Njk1YmYwNSIsInVzZXJfaWQiOiJveHhvbGltZiIsInJvbGUiOiJndWVzdCIsImp0aSI6IjBlMjk5Y2EyLWFkN2MtNDg2NS04YWMyLTkzMTI1Y2ZjNDAxZSIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJleHAiOjE2NjA0NTc5OTF9.owsI6tcqASkCcuvWPSRiyaXz8OF6MR8O0aCiajqDU-4")
//        
//  
    
        
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

        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
