//
//  ContentView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = ViewModel()

    
    var body: some View {
        ZStack {
            
            Colors.login
                .ignoresSafeArea()
            VStack {
                Text("LEARNALIZE")
                    .foregroundColor(.black)
                    .font(.largeTitle)
        
               textFields
               loginButton
                    .alert("failed to login", isPresented: $viewModel.failed, actions: {
                        Button("Ok", role: .cancel) {
                            viewModel.failed = false
                        }
                    })
                    .fullScreenCover(isPresented: $viewModel.model) {
                        MainView()
                    }
                
            }
           
            NavigationLink(destination: MainView(), isActive: $viewModel.showsMainView) {
                EmptyView()
            }
            if viewModel.isLoading {
                LoadingView(color: Colors.login)
            }
            
            
            
            
        }
        
        
        
         
            
    }
    // -MARK: UIElements
    var textFields: some View {
        VStack {
            textField(placeholder: "email", input: $viewModel.email, isEmpty: viewModel.email.isEmpty)
               
            secureField(placeholder: "password", input: $viewModel.password, isEmpty: viewModel.password.isEmpty)
             
                
        }
        .padding()
        .padding()
        
        
    }
    var loginButton: some View {
        Button {
            viewModel.isLoading = true
            viewModel.login()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 50, alignment: .center)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Text("Login")
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginView()
    }
}
