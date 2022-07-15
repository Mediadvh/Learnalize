//
//  ActivityCard.swift
//  Learnalize
//
//  Created by Media Davarkhah on 1/2/1401 AP.
//

import SwiftUI

func activityCard(isAbleToJoin: Bool,showsUsername: Bool,activity: Activity, color: Color, participants: Int) -> some View {
    return VStack (alignment: .leading) {
        if(showsUsername) {
            usernameButton(imageName: "person.circle.fill")
        }
        
       ZStack {
           color
               .cornerRadius(10)
           VStack {
               Text("studying \(Text("\(activity.name)").bold()), do you want to join me?")
                   .font(.title2)
                   .fixedSize(horizontal: false, vertical: true)
                   .padding()
               Spacer(minLength: 5)
               HStack {
                   Text("\(participants) participants")
                       .font(.body)
                       .padding()
                   Spacer()
                   if(isAbleToJoin) {
                       joinButton
                           .padding()
                           .foregroundColor(Color("background"))
                   }
               }
               Spacer(minLength: 10)
           }
            
        }
    }
}

// TODO: fix duality
func activityList(isAbleToJoin: Bool,showsUsername: Bool ,model: [Activity]) -> some View {
  
    List {
        //let colors = ["activityCard 1", "activityCard 2", "activityCard 3", "activityCard 4"]
        ForEach(model, id: \.self) { item in
            NavigationLink(destination: ActivityView()) {
                activityCard(isAbleToJoin: isAbleToJoin,showsUsername: showsUsername,activity: item, color: Color(item.tagColor), participants: 10)
            }
        }  .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        
    }
    .refreshable {
        
    }
}
