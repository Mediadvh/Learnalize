//
//  ChatLogView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/11/1401 AP.
//

import SwiftUI
let fakeuser = User(fullName: "hi", picture: "pic1", email: "media.svhsnikds@gmail.com", password: "sadkjnbh", username: "media_dh", id: "dsakjnhbgvsdahjbk")

struct ChatLogView: View {
    @Environment(\.presentationMode) var presentationMode
    static let emptyScrollToString = "Empty"
    var receiver: User
    init(receiver: User) {
        self.receiver = receiver
        self.viewModel = ViewModel(receiver: receiver)
        
    }
   
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack (spacing: 15) {
               ZStack {
                backButton
                       .multilineTextAlignment(.leading)
                       .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.receiver?.username ?? "")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer(minLength: 50)
                }
               
            }.padding()
                .background(Colors.background)
                            
            messages
        }
        .navigationBarHidden(true)
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground).ignoresSafeArea())
        }
            
                            
    }
    
    var messages: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ForEach(viewModel.messages, id: \.self) { message in
                        VStack {
                            if message.senderId == Authentication.shared.getCurrentUserUid() {
                                senderMessages(text: message.text)
                            } else {
                                receiverMessages(text: message.text)
                            }
                        }
                    }
                    HStack { Spacer() }
                        .id(Self.emptyScrollToString)
                    
                }
                .onReceive(viewModel.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
                
                
            }
           
        }
//        .navigationBarHidden(true)
//        .background(Color(.init(white: 0.95, alpha: 1)))
//        .safeAreaInset(edge: .bottom) {
//            chatBottomBar
//                .background(Color(.systemBackground).ignoresSafeArea())
//        }
    }
    
    var sendButton: some View {
        Button {
            viewModel.send()
        } label: {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.blue)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .cornerRadius(4)
    }
    var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Description", text: $viewModel.text)
                .font(.body)
                .padding()
//                .border(Color(.darkGray))
           sendButton
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    func senderMessages(text: String) -> some View {
        HStack {
            Spacer()
            HStack {
                Text(text)
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    func receiverMessages(text: String) -> some View  {
        HStack {
           
            HStack {
                Text(text)
                    .foregroundColor(.black)
                    .font(.body)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
        
    }
    var backButton: some View {
        Button {
            withAnimation(.linear) {
                presentationMode.wrappedValue.dismiss()
            }
            
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20))
                .foregroundColor(.black)
            Text("Chat")
                .foregroundColor(Colors.accent)
                .font(.body)
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(receiver: fakeuser)
        }
       
    }
}
