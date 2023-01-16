//
//  EditProfileView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/30/1401 AP.
//

import SwiftUI

struct EditProfileView: View {
  
    @ObservedObject var viewModel = ViewModel()
    @State var fullNameEnabled = false
    @State var emailEnabled = false
    @State var usernameEnabled = false
    @State var editFullNameText = "Edit"
    @State var editemailText = "Edit"
    @State var editusernameText = "Edit"
   
    
    @State var FullNamePlaceholder = "full name"
    @State var emailPlaceholder = "email"
    @State var usernamePlaceholder = "username"

    
    @State var fullNameInput = ""
    @State var emailInput = ""
    @State var usernameInput = ""
    
    
    var body: some View {
        ZStack {
            Colors.login
                .ignoresSafeArea()
            VStack {
                Spacer()
                profileButton
    
                    .padding()
                fullNameField
                    .padding()
                usernameField
                    .padding()
                emailField
                    .padding()
                saveButton
                    .padding()
                Spacer()
                
            }
        }
       
        .sheet(isPresented: $viewModel.profileButtonTapped) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.newImage)
        }
        .alert("are you sure you want to save changes?", isPresented: $viewModel.showSavePrompt) {
            
            Button("Cancel", role: .cancel) {
                viewModel.showSavePrompt = false
            }
            Button("Save", role: .destructive) {
                viewModel.saveChanges()
                viewModel.showSavePrompt = false
            }
        }
        
    }
    
    var profileButton: some View {
        Button {
            viewModel.tapProfileButton()
        } label: {
            if viewModel.newImage != UIImage(named: "profile") {
                Image(uiImage: viewModel.newImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120, alignment: .center)
                    .clipShape(Circle())
                    .foregroundColor(.black)
                    
            } else {
                profileImage(pic: viewModel.currentImageName, size: 100)
            }

        }
    }
    var fullNameField: some View {
   
            HStack {
                textField(placeholder: FullNamePlaceholder, input: $fullNameInput, isEmpty: true)
                .disabled(fullNameEnabled)
                .padding()
                .frame(width:(UIScreen.screenWidth / 2 ) + 80, height: 50, alignment: .center)
                fullNameEditButton
            }


    }
    var usernameField: some View {
       
               
            HStack {
                textField(placeholder: usernamePlaceholder, input: $usernameInput, isEmpty: true)
                    .disabled(usernameEnabled)
                    .padding()
                    .frame(width:(UIScreen.screenWidth / 2 ) + 80, height: 50, alignment: .center)
                usernameEditButton
            }



        
    }
    var emailField: some View {
      
        
        
        HStack {
            
            textField(placeholder: emailPlaceholder, input: $emailInput, isEmpty: true)
                .disabled(emailEnabled)
                .padding()
                .frame(width:(UIScreen.screenWidth / 2 ) + 80, height: 50, alignment: .center)
            
            emailEditButton
          
            
            
        }
        
    }
    
    
    var fullNameEditButton: some View {
        Button {
           
            if editFullNameText == "Edit" {
                self.editFullNameText = "Done"
                self.fullNameEnabled = false
                self.FullNamePlaceholder = ""
                self.fullNameInput = viewModel.fullName
            } else {
                self.viewModel.fullName = fullNameInput
                self.editFullNameText = "Edit"
                self.fullNameEnabled = true
                self.FullNamePlaceholder = "fullname"
                self.fullNameInput = ""
                
            }
           
        } label: {
            Text(editFullNameText)
                .foregroundColor(.black)
                .font(.system(size: 20))
        }
    }
    var usernameEditButton: some View {
        Button {
           
            if editusernameText == "Edit" {
                self.editusernameText = "Done"
                self.usernameEnabled = false
                self.usernamePlaceholder = ""
                self.usernameInput = viewModel.username
            } else {
                self.viewModel.username = usernameInput
                self.editusernameText = "Edit"
                self.usernameEnabled = true
                self.usernamePlaceholder = "username"
                self.usernameInput = ""
            }
           
        } label: {
            Text(editusernameText)
                .foregroundColor(.black)
                .font(.system(size: 20))
        }
    }
    
    var emailEditButton: some View {
        Button {
           
            if editemailText == "Edit" {
                self.editemailText = "Done"
                self.emailEnabled = false
                self.emailPlaceholder = ""
                self.emailInput = viewModel.email
            } else {
                self.viewModel.email = emailInput
                self.editemailText = "Edit"
                self.emailEnabled = true
                self.emailPlaceholder = "email"
                self.emailInput = ""
            }
           
        } label: {
            Text(editemailText)
                .foregroundColor(.black)
                .font(.system(size: 20))
        }
    }
    
    var saveButton: some View {
        Button {
            viewModel.showSavePrompt = true
        } label: {
            
            Text("save")
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(10)
                
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
