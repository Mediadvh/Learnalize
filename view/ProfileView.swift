//
//  ProfileView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    var userId: String?
    var showBackButton: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ViewModel()
    @State var index = 0
    
    init(id: String? = Authentication.shared.getCurrentUserUid(), showBackButton: Bool? = true) {
        userId = id
        self.showBackButton = showBackButton ?? true
    }

    var body: some View {
        VStack {
            topHeader
            middleHeader
            optionsHeader
            if index == 0, let activities = viewModel.activities  {
                activityList(activities: activities, isAbleToJoin: false, showsUsername: false)
                    .background(.clear)
            } else if index == 1 {
                UserResultView(users: viewModel.followers, destination: .none)
                    .background(.clear)
            } else {
                UserResultView(users: viewModel.followings, destination: .none)
                    .background(.clear)
            }
            Spacer(minLength: 0)
            
        }
        .navigationBarHidden(true)
        .onAppear() {
            if let userId = userId {
                viewModel.userIDToShow = userId
            }
            viewModel.setup()
            
        }
        .alert("Failed to logout!", isPresented: $viewModel.failLogOut, actions: {
            Button("Ok", role: .cancel) {
                viewModel.failLogOut = false
            }
        })
        .fullScreenCover(isPresented: $viewModel.loggedOut) {
            RegisterView()
        }
        .fullScreenCover(isPresented: $viewModel.showChat) {
            if let user = viewModel.user {
                ChatLogView(receiver: user)
            }
            
        }
        
        
        
    }
    var middleHeader: some View {
        HStack {
            
            
            profileImage(pic: viewModel.user?.picture ?? "")
            //            VStack (alignment: .leading, spacing: 12){
            Text(viewModel.user?.username ?? "Loading...")
                .font(.title)
                .foregroundColor(Colors.username)
            
            
            //            }
                .padding(.leading,20)
            
            Spacer(minLength: 0)
            if viewModel.user?.id != Authentication.shared.getCurrentUserUid() {
                message
                    
                    
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.top,10)
        
        
    }
    var topHeader: some View {
        
        HStack(spacing: 15) {
            if showBackButton {
                backButton
            } else {
                logoutButton
            }
            
            
            
            Spacer(minLength: 0)
            
            if let canFollow = viewModel.canFollow {
                if canFollow {
                    followButton
                } else {
                    editButton
                }
            }
            
            
        }
        .padding()
        
    }
    
   var optionsHeader: some View {
       HStack {
           activitiesButton
           Spacer(minLength: 0)
           followersButton
           Spacer(minLength: 0)
           followingsButton
          
       }
       .padding(.horizontal,20)
           .padding(.vertical)
           .background(Colors.background)
           .cornerRadius(8)
           .shadow(color: Color.black.opacity(0.5), radius: 5, x: 8, y: 8)
           .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
           .padding(.horizontal)
           .padding(.top,25)
       
   }
    var activitiesButton: some View {
        Button {
            self.index = 0
        } label: {
                
            Text("\(viewModel.activityCount) activities")
                .font(.body)
                .foregroundColor(self.index == 0 ? Color.white : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(self.index == 0 ? Color.blue: .clear)
                .cornerRadius(10)
        }
        
    }
    var followersButton: some View {
        Button {
            viewModel.showsFollowers = true
            self.index = 1
        } label: {
     
                Text("\(viewModel.followerCount) followers")
                .font(.body)
                .foregroundColor(self.index == 1 ? Color.white : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(self.index == 1 ? Color.blue: .clear)
                .cornerRadius(10)
        }
        
    }
    var followingsButton: some View {
        Button {
            viewModel.showsFollowings = true
            self.index = 2
        } label: {
          
                Text("\(viewModel.followingCount) followings")

                .font(.body)
                .foregroundColor(self.index == 2 ? Color.white : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(self.index == 2 ? Color.blue: .clear)
                .cornerRadius(10)
        }
        
    }
    var editButton: some View {
        Button {
            // edit tapped
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(Colors.editButton)
                    .cornerRadius(10)
                    .frame(width: 150,height: 45)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(0)
                        
               
            }
           
        }
    }
    var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    .frame(width: 100,height: 45)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
                Text("Logout")
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(0)
            }
            
            
        }
        
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20))
                .foregroundColor(.black)
            Text("Profile")
                .foregroundColor(Colors.accent)
                .font(.body)
        }
    }
    func profileImage(pic: String) -> some View {
        VStack {
            if let url = URL(string: pic) {
                WebImage(url:url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(100)
                    .foregroundColor(Color("accent"))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
            } else  {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(100)
                    .foregroundColor(Color("accent"))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
            }
        }
    }
    
   
    var message: some View {
        Button {
            if let _ = viewModel.user {
                viewModel.showChat = true
            }
            
        } label : {
            ZStack {
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .frame(width: 50,height: 50)

                   Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12))

            }
            
        }
        
    }
    
    

    var followButton: some View {
        Button {
            viewModel.followButtonTapped()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(viewModel.followBackgroundColor)
                    .cornerRadius(10)
                    .frame(width: 150,height: 45)
                Text(viewModel.followButtonState.rawValue)
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(0)
                        
               
            }
        }
    }
//    // activity cards
//    func activityCard(isAbleToJoin: Bool,showsUsername: Bool,activity: Activity, color: Color, participants: Int) -> some View {
//        return VStack (alignment: .leading) {
//            if(showsUsername) {
//                usernameButton(imageName: "person.circle.fill")
//            }
//
//           ZStack {
//               color
//                   .cornerRadius(10)
//               VStack {
//                   Text("studying \(Text("\(activity.name)").bold()), do you want to join me?")
//                       .font(.title2)
//                       .fixedSize(horizontal: false, vertical: true)
//                       .padding()
//                   Spacer(minLength: 5)
//                   HStack {
//                       Text("\(participants) participants")
//                           .font(.body)
//                           .padding()
//                       Spacer()
//                       if(isAbleToJoin) {
//                           joinButton(activity: activity)
//                               .padding()
//                               .foregroundColor(Color("background"))
//                       }
//                   }
//                   Spacer(minLength: 10)
//               }
//
//            }
//        }
//    }

   
//    func activityList(isAbleToJoin: Bool,showsUsername: Bool ,model: [Activity]) -> some View {
//
//        List {
//            //let colors = ["activityCard 1", "activityCard 2", "activityCard 3", "activityCard 4"]
//            ForEach(model, id: \.self) { item in
//                NavigationLink(destination: ActivityView()) {
//                    activityCard(isAbleToJoin: isAbleToJoin,showsUsername: showsUsername,activity: item, color: Color(item.tagColor), participants: 10)
//                }
//            }  .listRowBackground(Color.clear)
//                .listRowSeparator(.hidden)
//
//        }
//        .refreshable {
//
//        }
//    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView()
            ProfileView()
                .preferredColorScheme(.dark)
        }
    }
}
