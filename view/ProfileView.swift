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
    @StateObject var viewModel = ViewModel()
    
    init(id: String? = Authentication.shared.getCurrentUserUid()) {
        userId = id
    }

    var body: some View {
//        NavigationView {
        
            VStack {

               HStack {
                   Spacer()
                    if viewModel.picFromWeb {
                        if let pic = viewModel.webPicture {
                            webPictureAndName(image:pic, username: viewModel.username)
                                .padding()
                        }
                    } else {
                        pictureAndName(image: viewModel.defaultPicture, username: viewModel.username)
                            .padding()

                    }
                       Spacer()
                    
                   VStack {
                       if viewModel.canFollow {
                           followButton
                            
                       }
                       followers()
                      
                       followings()
                          
                   }
                   Spacer()
                    
                }
               .frame(alignment: .top)
               
                
                
                //            .border(Color("accent"), width: 4)
                Spacer(minLength: 50)
                Text("recent activities")
                    .font(.title3)
                    
                if let activities = viewModel.activities {
                    activityList(model: activities)
                }
              
               
            }
            .sheet(isPresented: $viewModel.showsFollowers) {
                UserList(users: viewModel.followers, selectable: false)
            }
            .sheet(isPresented: $viewModel.showsFollowings) {
                UserList(users: viewModel.followings, selectable: false)
            }
            .onAppear() {
                if let userId = userId {
                    viewModel.userIDToShow = userId
                }
                viewModel.setup()
                
            }
            
        
    }
    
    // MARK: UIElemets
    
    func pictureAndName(image: UIImage,username: String) -> some View {
        return  VStack {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(100)
                .foregroundColor(Color("accent"))
            Text(username)
                .foregroundColor(Color("accent"))
            
           
        }
        
    }
    func webPictureAndName(image: WebImage,username: String) -> some View {
        return  VStack {
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(100)
            Text(username)
                .font(.largeTitle)
                .foregroundColor(Color("accent"))
           
        }
        
    }
    
    func followers() -> some View {
        Button {
            viewModel.getFollowers()
            viewModel.showsFollowers = true
        } label : {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(Colors.accent))
                    .cornerRadius(10)
                    .frame(width: 150,height: 45)
                
                Text("followers")
                
                
                    .foregroundColor(Color(Colors.background))
                    .font(.body)
                    .lineLimit(0)
            }
        }
    }
    
    func followings() -> some View {
        Button {
            viewModel.getFollowings()
            viewModel.showsFollowings = true
        } label : {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(Colors.accent))
                    .cornerRadius(10)
                    .frame(width: 150,height: 45)
                
                Text("followings")
                
                    .foregroundColor(Color(Colors.background))
                    .font(.body)
                    .lineLimit(0)
            }
        }
        
    }
    // TODO: fix duality
    func activityList(model: [Activity]) -> some View {
        List {
           
            ForEach(model, id: \.self) { item in

                activityCard(isAbleToJoin: false,showsUsername: false,activity: item, color: Color(item.tagColor), participants: 10)

            }  .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .refreshable {
            viewModel.showActivities()
        }

    }
    var followButton: some View {
        Button {
            viewModel.followButtonTapped()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(viewModel.followColor))
                    .cornerRadius(10)
                    .frame(width: 150,height: 45)
                Text(viewModel.followButtonState.rawValue)
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(0)
                        
               
            }
        }
    }

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
