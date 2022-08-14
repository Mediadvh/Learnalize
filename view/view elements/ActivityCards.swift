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
    @State var username: String?
    @State var token: String? = ""
    @State var join: Bool = false
   
    init(isAbleToJoin: Bool, showsUsername: Bool, selectedItem: Activity) {
        self.isAbleToJoin = isAbleToJoin
        self.showsUsername = showsUsername
        self.selectedItem = selectedItem
        self.retrieveHost()
    }
    var body: some View {
        
        VStack (alignment: .leading) {
           
            if showsUsername == true {
                usernameButton(imageName: "person.circle.fill", username: username ?? "Loading")
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
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 8, y: 8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -8, y: -8)
                
                
            }
           
            Spacer(minLength: 30)
            
        }
        
        .fullScreenCover(isPresented: $join) {
            if let token = token, let username = username {
                Room(activity: selectedItem, userId: username, token: token)
            
            } else {
                Text("nothing to show here except: \(token ?? "no token")")
            }
        }

        
    }
    
    func joinButton(activity: Activity) -> some View {
        Button {
            RoomAPIHandler.roomForGuest(roomId: activity.uid, userId: username ?? "N/A") { res, error in
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
            .foregroundColor(Colors.accent)
        }
        .buttonStyle(PlainButtonStyle())
       
       
    }
    
    func retrieveHost() {
        selectedItem.fetchHost { user, error  in
            guard error == nil, let user = user else {
              
                return
            }
            let ussername = user.username
            print(ussername ?? "Continue from here******************************")
            self.username = ussername
            
        }
    }
}

struct activityList: View {
    var activities: [Activity]
    var isAbleToJoin: Bool
    var showsUsername: Bool
    
    @State private var selectedItem: Activity?
    var body: some View {
        ZStack{
            Color.red
            List {
                ForEach(activities) { item in
                    
                    activityCard(isAbleToJoin: isAbleToJoin, showsUsername: showsUsername, selectedItem: item)
                        .listRowBackground(Color.clear)
                        
                        .listRowSeparator(.hidden, edges: .all)
                
                }
            }
        }
        
    }
    
}

let host = User(fullName: "media davarkhah", picture: "profile", email: "media.dvhsa@yahoo.com", password: "sdjhejwhfc", username: "Wedijscu", id: "wdnikjiw")
struct activityList_Previews: PreviewProvider {
    static var previews: some View {
        activityList(activities: [Activity(name: "spanish", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef", host: host), Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef"), Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef"), Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef"),Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef")], isAbleToJoin: true, showsUsername: true)
    }
}
