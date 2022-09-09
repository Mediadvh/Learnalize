//
//  MainView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI


//let activity = Activity(name: "Test", description: "test this out", participantsLimit: 4, createdAt: "2 august", uid: "wjsnfeuhwjiaodiwedhijkwjd", active: true, hostId: "dksjhcidojwak", host: User(fullName: "media", picture: "s", email: "Asasdas", password: "ASdda", username: "Adsd", id: "ad"))
struct MainView: View {
//    let isAdmin = true
    var body: some View {
        if (Authentication.shared.isAdmin()) {
            SearchView()
        }
//       else
        else if(Authentication.shared.isLoggedIn()) {
//
//        Room(activity: activity, token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjJkZDAzOTdjMTY2NDAwNjU2OTViZWY0Iiwicm9vbV9pZCI6IjYyZmUwYzQyYjFlNzgwZTc4YzNiYTA5YyIsInVzZXJfaWQiOiJkaWxhc3hsayIsInJvbGUiOiJndWVzdCIsImp0aSI6ImZhYjI1MjljLTBjNDQtNDVhOS1iYzQzLWNlN2FjNmYxY2YwNiIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJleHAiOjE2NjEwNzk5Mjh9.eKl7SqyFUK2qIMmCj5-FB3ZijdMDI2dbfGRtKERflsI", participant: Participant(role: .guest, askedForPermission: false, uid: "duqasyghjeuaisudhjx"))
      
        



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
