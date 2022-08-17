//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
let activity = Activity(name: "Test", description: "test this out", participantsLimit: 4, createdAt: "2 august", uid: "wjsnfeuhwjiaodiwedhijkwjd", active: true, hostId: "dksjhcidojwak", host: User(fullName: "media", picture: "s", email: "Asasdas", password: "ASdda", username: "Adsd", id: "ad"))
struct MainView: View {
//    let isAdmin = true
    var body: some View {
//        if (isAdmin == true) {
//            SearchView()
//        }
//       else
        if(Authentication.shared.isLoggedIn()) {
        
//        Room(activity: activity, token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjJkZDAzOTdjMTY2NDAwNjU2OTViZWY0Iiwicm9vbV9pZCI6IjYyZGQwNmQzYzE2NjQwMDY1Njk1YmYwNSIsInVzZXJfaWQiOiJwZnJuZnZpdyIsInJvbGUiOiJwcml2aWxlZ2VkLWd1ZXN0IiwianRpIjoiZmFlNGU4OTAtYmQ4OS00MTBjLTg1OWMtYWY5ZjY3MGE4ODQzIiwidHlwZSI6ImFwcCIsInZlcnNpb24iOjIsImV4cCI6MTY2MDc0ODI2MX0.IwZQvJ5TN9FrortZ_0RjNok0iChawNz0XfS7wRO-oRM", participant: Participant(role: .host, askedForPermission: false, uid: "duqasyghjeuaisudhjx"))
        
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

//
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
