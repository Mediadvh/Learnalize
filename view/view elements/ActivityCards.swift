//
//  ActivityCard.swift
//  Learnalize
//
//  Created by Media Davarkhah on 1/2/1401 AP.
//
import SwiftUI

// activity cards

struct activityCard: View {
    var isAbleToJoin: Bool
    var showsUsername: Bool
    var selectedItem: Activity
    @State var token: String? = ""
    @State var join: Bool = false
    
    var body: some View {
        
        VStack (alignment: .leading) {
            if(showsUsername) {
                usernameButton(imageName: "person.circle.fill")
            }
            
            ZStack {
                Color(selectedItem.tagColor)
                    .cornerRadius(10)
                VStack {
                    Text("studying \(Text("\(selectedItem.name)").bold()), do you want to join me?")
                        .font(.title2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Spacer(minLength: 5)
                    HStack {
                        Text("10 participants")
                            .font(.body)
                            .padding()
                        Spacer()
                        if(isAbleToJoin) {
                            joinButton(activity: selectedItem)
                                .padding()
                                .foregroundColor(Color("background"))
                        }
                    }
                    Spacer(minLength: 10)
                }
                
            }
            
        }
        .fullScreenCover(isPresented: $join) {
            if let token = token {
                Room(activity: selectedItem, userId: Authentication.shared.getCurrentUserUid()!, token: token)
            } else {
                Text("nothing to show here except: \(token ?? "no token")")
            }
        }

        
    }
    
    func joinButton(activity: Activity) -> some View {
        Button {
            RoomAPIHandler.roomForGuest(roomId: activity.uid, userId: Authentication.shared.getCurrentUserUid()!) { res, error in
                guard let res = res else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.token = res.token
                    print(res.token)
                    self.join = true
                    print("\(self.selectedItem.name) selected")
                    
                   
                }
              
            }
           
        } label: {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                Text("join")
                    .font(.body)
                
            }
        }
        .buttonStyle(PlainButtonStyle())
       
       
    }
}


struct activityList: View {
    var activities: [Activity]
    var isAbleToJoin: Bool
    var showsUsername: Bool
    
    @State private var selectedItem: Activity?
    var body: some View {
        
        ForEach(activities, id: \.self) { item in
            
            activityCard(isAbleToJoin: isAbleToJoin, showsUsername: showsUsername, selectedItem: item)
                
        }
        .onDelete { index in
            print("DELETED THIS...")
        }
        
            
        
    }
    
}
