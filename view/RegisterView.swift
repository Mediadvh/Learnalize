//
//  registerView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI


struct RegisterView: View {
   
    @StateObject private var modelView = ModelView()
    
   
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("register")
                    .ignoresSafeArea()
                    .navigationBarHidden(true)
                VStack {
                    Text("LEARNALIZE")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    profileButton
                    textFieldsVStack
                        
                    registerButton
                    NavigationLink(destination: LoginView()) {
                        loginButton
                    }
                    NavigationLink(destination: MainView(), isActive: $modelView.showsMainView) {
                        EmptyView()
                    }
                }
                if modelView.isLoading {
                    LoadingView()
                }
            } .navigationTitle("Register")
        }
        .accentColor(Color("accent"))
        .sheet(isPresented: $modelView.profileButtonTapped) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $modelView.image)
        }
    }
    
    
    // MARK: -UIElements
    var textFieldsVStack: some View {
        return VStack {
            
            textField(placeholder: "full name", input: $modelView.fullname, isEmpty: modelView.fullname.isEmpty)
            textField(placeholder: "user name", input: $modelView.username, isEmpty: modelView.username.isEmpty)
            textField(placeholder: "email", input: $modelView.email, isEmpty: modelView.email.isEmpty)
            secureField(placeholder: "password", input: $modelView.password, isEmpty: modelView.password.isEmpty)
            
        }
        .padding()
        .padding()
    }
    
    var profileButton: some View {
        Button {
            modelView.tapProfileButton()
        } label: {
            Image(uiImage: modelView.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(Circle())
                .foregroundColor(.black)
        }
    }
    
    
    var registerButton: some View {
        Button {
            modelView.isLoading = true
            modelView.registerUser()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 50, alignment: .center)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Text("register")
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
    }

    var loginButton: some View {
        HStack {
            Text("already have an account?")
            Text("login")
                .font(.bold(.body)())
        }
        .foregroundColor(.black)
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
        RegisterView()
            .preferredColorScheme(.dark)
    }
}
