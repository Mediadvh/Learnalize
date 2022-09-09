//
//  UsersList.swift
//  Learnalize
//
//  Created by Media Davarkhah on 3/19/1401 AP.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
enum Destination {case profileView, chatLogView, none}

struct UserResultView: View {
    @Environment (\.presentationMode) var presentationMode
    @State var users: [User]
    var destination: Destination
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        switch destination {
        case .profileView:
            userList
        case .chatLogView:
            NavigationView {
                VStack {
                    if destination == .chatLogView {
                        cancelButton
                            .padding(.leading)
                    }
                    
                    userList
                }.navigationBarHidden(true)
            }
        case .none:
            userList
        }
        
    }
    func userCard(user: User) -> some View{
        HStack(spacing: 20) {
            // let image = FireStoreManager.shared.getImage(with: user.picture)
            if let url = URL(string: user.picture) {
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(100)
                    .foregroundColor(Colors.accent)
            } else {
                Image(uiImage: Images.profile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(100)
                    .foregroundColor(Colors.accent)
            }
            Text(user.username)
                .font(.title3)
                .foregroundColor(Colors.accent)
        }.background(.clear)
    }
    var userList: some View {
        
        VStack {
            if Authentication.shared.isAdmin() {
                listWithDelete
            } else {
                listWithoutDelete
            }
            
        }
        
    }
    var listWithDelete: some View {
        List {
            ForEach(users) { item in
                switch destination {
                case .profileView:
                    NavigationLink(destination: ProfileView(id: item.id)) {
                        userCard(user: item)
                            .frame(width: 300, height: 100, alignment: .leading)
                    }
                case .chatLogView:
                    NavigationLink(destination: ChatLogView(receiver: item)) {
                        userCard(user: item)
                            .frame(width: 300, height: 100, alignment: .leading)
                    }
                    
                case .none:
                    userCard(user: item)
                        .frame(width: 300, height: 100, alignment: .leading)
                }
                
            }
            .onDelete(perform: delete)
        }
        .background(.clear)
        
    }
    var listWithoutDelete: some View {
        List {
            ForEach(users) { item in
                switch destination {
                case .profileView:
                    NavigationLink(destination: ProfileView(id: item.id)) {
                        userCard(user: item)
                            .frame(width: 300, height: 100, alignment: .leading)
                    }
                case .chatLogView:
                    NavigationLink(destination: ChatLogView(receiver: item)) {
                        userCard(user: item)
                            .frame(width: 300, height: 100, alignment: .leading)
                    }
                    
                case .none:
                    userCard(user: item)
                        .frame(width: 300, height: 100, alignment: .leading)
                }
                
            }
           
        }
        .background(.clear)
        
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        FireStoreManager.shared.deleteUser(with: users[index].id) 
        users.remove(atOffsets: offsets)
    }
    var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("cancel")
        }
    }

}

extension UserResultView {
    @MainActor class ViewModel: ObservableObject {
        
    }
}
