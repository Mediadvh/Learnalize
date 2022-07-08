//
//  registerView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI


struct RegisterView: View {
   
    @StateObject private var viewModel = ViewModel()
    
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
                        .alert("failed to sign up", isPresented: $viewModel.failed, actions: {
                            Button("Ok", role: .cancel) { }
                        })
                    NavigationLink(destination: LoginView()) {
                        loginButton
                    }
                    NavigationLink(destination: MainView(), isActive: $viewModel.showsMainView) {
                        EmptyView()
                    }
                }
                if viewModel.isLoading {
                    LoadingView(color: Colors.register)
                }
            } .navigationTitle("Register")
        }
        .accentColor(Color("accent"))
        .sheet(isPresented: $viewModel.profileButtonTapped) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image)
        }
    }
    
    
    // MARK: -UIElements
    var textFieldsVStack: some View {
        return VStack {
            
            textField(placeholder: "full name", input: $viewModel.fullname, isEmpty: viewModel.fullname.isEmpty)
            textField(placeholder: "user name", input: $viewModel.username, isEmpty: viewModel.username.isEmpty)
            textField(placeholder: "email", input: $viewModel.email, isEmpty: viewModel.email.isEmpty)
            secureField(placeholder: "password", input: $viewModel.password, isEmpty: viewModel.password.isEmpty)
            
        }
        .padding()
        .padding()
    }
    
    var profileButton: some View {
        Button {
            viewModel.tapProfileButton()
        } label: {
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(Circle())
                .foregroundColor(.black)
        }
    }
    
    
    var registerButton: some View {
        Button {
            viewModel.isLoading = true
            viewModel.registerUser()
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
