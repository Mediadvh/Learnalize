//
//  PostActivityView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI


struct PostActivityView: View {
    @StateObject var viewModel = ViewModel()
    @State var pickedColor = Color("activityCard 1")
  
    var body: some View {
        NavigationView
        {
            VStack {
                Text("New Activity")
                activityDetail(activityInput: $viewModel.name, descriptionInput: $viewModel.description)
                postButton
                Spacer(minLength: 20)
            }
            .navigationBarHidden(true)
        }
       
    }
    // MARK: UIElements
    var postButton: some View {
        Button {
            // alert
            viewModel.post()
        } label : {
            Text("post")
                .frame(width: 100, height: 10)
                .padding()
                .background(Color("accent"))
                .foregroundColor(Color("background"))
                .cornerRadius(10)
        }
        .alert("posted Activity", isPresented: $viewModel.showingAlert) {
                    Button("OK", role: .cancel) { }
                }
    }

    func tag(color: String) -> some View {
        Button {
            pickedColor = Color(color)
        } label : {
            Circle()
                .strokeBorder(Color.black, lineWidth: 1)
                .background(Circle().fill(Color(color)))
        }
    }
    var tagPanel: some View {
        HStack(spacing: 2) {
                tag(color: "activityCard 1")
                tag(color: "activityCard 2")
                tag(color: "activityCard 3")
                tag(color: "activityCard 4")
        }
        .frame(height: 50)
    }
    var numberPicker: some View {
        
        Picker(selection: $viewModel.participantsLimit, label: Text("Picker")) {
            Text("1").tag(1)
            Text("2").tag(2)
            Text("3").tag(3)
            Text("4").tag(4)
            Text("5").tag(5)
            Text("6").tag(6)
            Text("7").tag(7)
            Text("8").tag(8)
            Text("9").tag(9)
            Text("10").tag(10)
        }
        .border(.black, width: 1)
        .cornerRadius(10)
    }
    func activityDetail(activityInput: Binding<String>, descriptionInput: Binding<String>) -> some View {
       
        ZStack {
            pickedColor
                .cornerRadius(20)
                .padding()
                
            VStack(spacing: 20) {
                Text("Activity:")
                    .foregroundColor(Color("accent"))
                    .font(.body)
               
                textField(placeholder: "", input: activityInput, isEmpty: true)
                    .padding()
                Text("Description:(optional)")
                    .font(.body)
               
                textField(placeholder: "", input: descriptionInput, isEmpty: true)
                    .padding()
                Text("number of people who can join:")
                    .font(.body)
                
                numberPicker
                Text("Tag:")
                    .font(.body)
                tagPanel
                   
            }
            .padding()
        }
        .padding()
    }
}

struct PostActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PostActivityView()
    }
}
