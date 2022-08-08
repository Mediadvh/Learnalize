//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
let activity = Activity(name: "Test", description: "test this out", participantsLimit: 4, createdAt: "2 august", uid: "wjsnfeuhwjiaodiwedhijkwjd", active: true, hostId: "dksjhcidojwak")
struct MainView: View {
    let isAdmin = true
    var body: some View {
//        if (isAdmin == true) {
//            SearchView()
//        }
//       else if(Authentication.shared.isLoggedIn()) {
            Room(activity: activity, userId: "media", token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjJkZDAzOTdjMTY2NDAwNjU2OTViZWY0Iiwicm9vbV9pZCI6IjYyZGQwNmQzYzE2NjQwMDY1Njk1YmYwNSIsInVzZXJfaWQiOiJxa3h2aXp6ayIsInJvbGUiOiJndWVzdCIsImp0aSI6ImU2MWUwYThiLWIxZWYtNDY2MC1hN2EzLWM0NDMyMTljNTc1NSIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJleHAiOjE2NjAwNTQyNDd9.PAFXy2o1yiEP6rrk3rClnhmkST6jPaTQeFpEW6gavF4")
//            TabView {
//                    HomeView()
//                        .tabItem {
//                            Label("Home", systemImage: "house")
//                        }
//                        .navigationTitle("Home")
//                    SearchView()
//                    .tabItem {
//                        Label("search", systemImage: "magnifyingglass")
//                    }
//                    PostActivityView()
//                        .tabItem {
//                            Label("Post", systemImage: "plus.circle")
//                                .font(.largeTitle)
//                        }
//
//                    ChatListView()
//                    .tabItem {
//                        Label("chat", systemImage: "message.fill")
//                    }
//                ProfileView(showBackButton: false)
//                    .tabItem {
//                        Label("profile", systemImage: "person.fill")
//                    }
//
//
//            }
//            .accentColor(Color("accent"))
//            .font(.largeTitle)
//            .ignoresSafeArea()
//
//
//        } else {
//            RegisterView()
//        }
//

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
