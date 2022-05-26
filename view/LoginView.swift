//
//  ContentView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI

struct LoginView: View {
    @StateObject var modelView = ModelView()

    
    var body: some View {
        ZStack {
            
            Color.teal
                .ignoresSafeArea()
            VStack {
                Text("LEARNALIZE")
                    .foregroundColor(.black)
                    .font(.largeTitle)
        
               textFields
                   
        
                loginButton
                    .fullScreenCover(isPresented: $modelView.model) {
                        MainView()
                    }
                
            }
           
            NavigationLink(destination: MainView(), isActive: $modelView.showsMainView) {
                EmptyView()
            }
            if modelView.isLoading {
                LoadingView()
            }
            
        }
        
        
        
         
            
    }
    // -MARK: UIElements
    var textFields: some View {
        VStack {
            textField(placeholder: "email", input: $modelView.email, isEmpty: modelView.email.isEmpty)
               
            secureField(placeholder: "password", input: $modelView.password, isEmpty: modelView.password.isEmpty)
             
                
        }
        .padding()
        .padding()
        
        
    }
    var loginButton: some View {
        Button {
            modelView.isLoading = true
            modelView.login()
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
