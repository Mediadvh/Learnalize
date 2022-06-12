//
//  ProfileView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ViewModel()
   

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.picFromWeb {
                    if let pic = viewModel.webPicture {
                        webPictureAndName(image:pic, username: viewModel.username)
                    }
                } else {
                    pictureAndName(image: viewModel.defaultPicture, username: viewModel.username)
                }
                
                
                HStack {
                    activitiesNumber(number: 10)
                        .padding()
                    Spacer()
                    friendsNumber(number: 15)
                        .padding()
                }.frame(height: 80)
                    .navigationBarHidden(true)
                
                //            .border(Color("accent"), width: 4)
                Spacer(minLength: 50)
                Text("recent activities")
                    .font(.title3)
                    
                if let activities = viewModel.activities {
                    activityList(model: activities)
                }
               
            }
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
                .font(.largeTitle)
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
    
    func activitiesNumber(number: Int) -> some View {
        Button {
            print("activitiesNumber tapped")
        } label : {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("accent"))
                    .cornerRadius(10)
              
                HStack {
                    Text("\(number)")
                    Text("Activities")
                }
            }
           
            .foregroundColor(Color("background"))
            .font(Font.system(size: 20))
        }
    }

    func friendsNumber(number: Int) -> some View {
        Button {
            print("friendsNumber tapped")
        } label : {
            ZStack{
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(Color("accent"))
                HStack {
                    Text("\(number)")
                    Text("Friends")
                }
                
            }
            .foregroundColor(Color("background"))
            .font(Font.system(size: 20))
        }

    }
    // TODO: fix duality
    func activityList(model: [Activity]) -> some View {
        List {
            let colors = ["activityCard 1", "activityCard 2", "activityCard 3", "activityCard 4"]
            ForEach(model, id: \.self) { item in

                activityCard(isAbleToJoin: false,showsUsername: false,activity: item, color: Color(colors.randomElement() ?? "activityCard 1"), participants: 10)

            }  .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .refreshable {
            viewModel.showActivities()
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
