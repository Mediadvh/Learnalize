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
    var showDeleteButton: Bool
    
    @ObservedObject var viewModel: ViewModel
    
    init(isAbleToJoin: Bool, showsUsername: Bool, selectedItem: Activity, showDeleteButton: Bool = true) {
        self.isAbleToJoin = isAbleToJoin
        self.showsUsername = showsUsername
        self.selectedItem = selectedItem
        self.viewModel = ViewModel(activity: selectedItem)
        self.showDeleteButton = showDeleteButton
    }
    var body: some View {
      
        VStack (alignment: .leading) {
            
            if showsUsername {
                usernameButton(imageName: viewModel.image, username: viewModel.username)
            }
            
            
            Spacer()
            ZStack {
                Color(selectedItem.tagColor)
                    .cornerRadius(10)
                    .shadow(color: Colors.accent.opacity(0.5), radius: 8, x: 8, y: 8)
                    .shadow(color: Colors.accent.opacity(0.1), radius: 8, x: -8, y: -8)
              
                cardInfo
                
                
                
            }
           
            Spacer(minLength: 30)
            
        }
        
        .fullScreenCover(isPresented: $viewModel.join) {
            if let token = viewModel.token, let participant = viewModel.participant  {
                Room(activity: selectedItem, token: token, participant: participant)
                    .edgesIgnoringSafeArea(.all)
            
            } else {
                Text("can't join")
            }
        }
        .fullScreenCover(isPresented: $viewModel.showProfileView) {
            ProfileView(id: selectedItem.hostId, showBackButton: true)
        }
        .alert("the participant limit on this activity has been reached, try another one!", isPresented: $viewModel.showLimitAlert) {
                    Button("OK", role: .cancel) {
                        viewModel.showLimitAlert = false
                    }
                }
        .alert("This activity is no longer active, try another one!", isPresented: $viewModel.showDeactivateAlert) {
                    Button("OK", role: .cancel) {
                        viewModel.showDeactivateAlert = false
                    }
                }
        .alert("successfully deleted activity!", isPresented: $viewModel.deletedActivity) {
            Button("OK", role: .cancel) {
                viewModel.deletedActivity = false
            }
        }
        


        
    }
    var cardInfo: some View {
        VStack {
            
            
            
            Text("studying \(Text("\(selectedItem.name)").bold()), do you want to join me?")
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            
            Text("description: \(selectedItem.description)")
                .font(.system(size: 13))
                .multilineTextAlignment(.leading)
                .padding()
                .lineLimit(.max)
       
            Spacer(minLength: 5)
            HStack {
               
                    
                Text("\(selectedItem.active ? "Active" : "Not Active")")
                    .font(.body)
                    .padding()
                Spacer()
                if isAbleToJoin && !Authentication.shared.isAdmin() {
                    joinButton(activity: selectedItem)
                        .padding()
                        .foregroundColor(Color("background"))
                }
                if showDeleteButton && Authentication.shared.isAdmin() {
                    deleteButton
                        .padding()
                }
                    
               
            }
            Spacer(minLength: 10)
            
            
        }
    }
    var deleteButton: some View{
        Button {
            viewModel.deleteActivity()
            
     
        } label: {
            let config = UIImage.SymbolConfiguration(
                pointSize: 20, weight: .medium, scale: .default)
            let image = UIImage(systemName: "trash", withConfiguration: config)!
            
            Image(uiImage: image)
                .foregroundColor(.red)
                .tint(.black)
        }
    }
    
    func joinButton(activity: Activity) -> some View {
        Button {
            
            viewModel.joinActivity(activity: activity)

           
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
    
    func usernameButton(imageName: String, username: String) -> some View {
        Button {
            viewModel.usernameButtonTapped()
        } label: {
            HStack {
                profileImage(pic: imageName, size: 50)
                 
                Text(viewModel.username)
                    .font(.body)
                    .foregroundColor(Colors.accent)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}


struct activityList: View {
    var activities: [Activity]
    var isAbleToJoin: Bool
    var showsUsername: Bool
    
    @State private var selectedItem: Activity?
    var body: some View {
        ZStack{
            Color.clear
            
            List(activities) { item in
                  
                    activityCard(isAbleToJoin: isAbleToJoin, showsUsername: showsUsername, selectedItem: item)
                   
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden, edges: .all)
                
            }
         
            
        }
        .background(Color.red)
        
    }
    
}

let host = User(fullName: "media davarkhah", picture: "profile", email: "media.dvhsa@yahoo.com", password: "sdjhejwhfc", username: "Wedijscu", id: "wdnikjiw")
let activities = [Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "1212", active: true, hostId: "ytrdef", host: host), Activity(name: "neki", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "21w12", active: true, hostId: "ytrdef"), Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "12", active: true, hostId: "ytrdef"), Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "46789", active: true, hostId: "ytrdef"),Activity(name: "german", description: "let's learn", participantsLimit: 7, createdAt: "qewrtyui", uid: "321", active: true, hostId: "ytrdef")]


struct activityList_Previews: PreviewProvider {
    static var previews: some View {
        activityList(activities: activities, isAbleToJoin: true, showsUsername: true)
    }
}

