//
//  ActivityView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.dismiss) var dismiss
    var participants = ["john doe"]
    var colortag = Colors.activityCard1
    var colortagAccent = Colors.activityCard1Accent
    @State var showParticipants = false
    var body: some View {
        ZStack {
            // TODO: replace with the activity color
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Activity name")
                    .font(.largeTitle)
                   
                whiteboard
                
                if showParticipants {
                    participantsView
                } else {
                    HStack {
                        
                        showParticipantsButton
                        leaveButton
                            .frame(width: 100, height: 50, alignment: .topTrailing)
                            .padding()
                        
                    }
                }
            }
        }
            
    }
    var participantsView: some View {
        
        VStack {
            Button {
                showParticipants = false
            } label: {
                Text ("dismiss")
                    .foregroundColor(.red)
                    .font(.headline)
            }
        
            ScrollView(.horizontal) {
                HStack {
                    ForEach(participants, id: \.self) { item in
                        // TODO: replace with video
                        VStack {
                            Image("pic2")
                            Text(item)
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                            
                    }
                }
                    
            }
                
            
        }.background(Color(colortagAccent))
            .ignoresSafeArea()
            .frame(height: 150, alignment: .bottom)
            
        
    }
    var whiteboard: some View {
        ZStack {
            Color.white
                .border(Color(colortag), width: 10)
            Text("White board")
                .font(.largeTitle)
        }
        
    }
    var leaveButton: some View {
        Button {
           dismiss()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                    .cornerRadius(10)
                Text("Leave")
                    .foregroundColor(.black)
            }
        }
    }
    var showParticipantsButton: some View {
        Button {
            showParticipants = true
        } label: {
            
            Text("show Participants")
                .foregroundColor(.blue)
                .font(.headline)
                .padding()
            
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
