//
//  MessagesView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/9/1401 AP.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
struct ChatListView: View {
   @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
        VStack {
            
            HStack(spacing: 16) {
                
                profileImage(pic: viewModel.currentUser?.picture  ?? "Profile")
                    .font(.system(size: 20, weight: .heavy))
                
                infoStack
                Spacer()
                
                
                
                
            }
            .padding()
            Rectangle()
                .frame(height: 2, alignment: .center)
            messageList
            //            if viewModel.showDefaultList {
            //                defaultList
            //                    .overlay(newMessageButton, alignment: .bottom)
            //            } else {
            //                messageList
            //                    .overlay(newMessageButton, alignment: .bottom)
            //            }
            Spacer()
            
        }.navigationBarHidden(true)
        //        .fullScreenCover(isPresented: $viewModel.showNewMessageList) {
        //
        //            UserResultView(users: viewModel.NewMessageList, destination: .chatLogView)
        //
        //
        //        }
        
        
        }
       
    }
   
    func profileImage(pic: String) -> some View {
        VStack {
            if let url = URL(string: pic) {
                WebImage(url:url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipShape(Circle())
                    .foregroundColor(.black)
//                    .overlay {
//                        Circle()
//                            .stroke(.black, lineWidth: 2)
//                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: -5, y: -5)
                    .padding(8)
            } else  {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipShape(Circle())
                    .foregroundColor(.black)
//                    .overlay {
//                        Circle()
//                            .stroke(.black, lineWidth: 2)
//                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: -5, y: -5)
                    .padding(8)
            }
        }
        
    }
   
//    var newMessageButton: some View {
//        Button{
//            viewModel.getNewMessageList()
//        } label: {
//            HStack {
//                Spacer()
//                Text("+ New Message")
//                    .font(.system(size: 16, weight: .bold))
//                Spacer()
//            }
//            .foregroundColor(.white)
//            .padding(.vertical)
//                .background(Color.blue)
//                .cornerRadius(32)
//                .padding(.horizontal)
//                .shadow(radius: 15)
//
//        }
//    }
    var infoStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.currentUser?.username ?? "Loading")
                .font(.system(size:24, weight:.bold))
            
            HStack {
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 14, height: 14)
                Text("online")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.lightGray))
            }
            
        }
    }
    var messageList: some View {
        ScrollView {
            ForEach(viewModel.recentChat) { chat in
                NavigationLink(destination: ChatLogView(receiver: chat.other)) {
                    recentChat(chat: chat)
                }
            }.padding(.bottom, 50)

        }
    }
    var defaultList: some View {
        ScrollView {
            EmptyView()
        }
    }
    func recentChat(chat: Chat) -> some View {
        VStack {
            HStack(spacing: 16) {
            
                profileImage(pic: chat.other.picture ?? " person.circle")
                    .font(.system(size: 32))

                VStack(alignment: .leading) {
                    Text(chat.other.username ?? "Loading...")
                        .font(.system(size:16, weight:.bold))
                    if chat.recentMessage.senderId == Authentication.shared.getCurrentUserUid()! {
                        Text(chat.recentMessage.text)
                            .font(.system(size: 16))
                            .foregroundColor(Color(.lightGray))
                    } else {
                        Text(chat.recentMessage.text)
                            .font(.system(size: 16))
                            .foregroundColor(Color(.black))
                    }
                   

                }
                Spacer()
              
                Text(chat.timeAgo)
                    .font(.system(size: 14, weight: .semibold))
             
                
                

              
            }
            Divider()
                .padding(.vertical, 8)

        }.padding(.horizontal)

    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}


