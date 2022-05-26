//
//  ProfileView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var modelView = ModelView()
   

    var body: some View {
        NavigationView {
            VStack {
                if modelView.picFromWeb {
                    if let pic = modelView.webPicture {
                        webPictureAndName(image:pic, username: modelView.username)
                    }
                } else {
                    pictureAndName(image: modelView.defaultPicture, username: modelView.username)
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
                    
                activityCollection(isAbleToJoin: false,showsUsername: false,model: ["Physics 101","Math","programming languages"])
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
