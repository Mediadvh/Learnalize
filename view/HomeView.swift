//
//  HomeView.swift
//  Learnalize
//
//  Created by Media Davarkhah on 12/27/1400 AP.
//

import SwiftUI

var model = ["Math", "C++","Python","german","swift","software process","IOT","fundamentals of programming", "Algebra 101","Physics 101" ]



struct HomeView: View {
    
    @StateObject var modelView = ModelView()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
            Color("background")
            Text("Learnalize")
                .font(.largeTitle)
                .padding()
                .navigationBarHidden(true)
            VStack(alignment: .trailing) {
                
                // TODO: add a navigation view somewhere appropriate
                //                    NavigationLink(destination: ProfileView()) {
                //                        profileButton
                //                    }
                
                activityCollection(isAbleToJoin: true, showsUsername: true, model: model)
                
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("accent"))
            .navigationBarHidden(true)
            
        }
        
    }
    
    // MARK: UIElements
    var profileButton: some View {
    
        Image(systemName: "person.fill")
            .font(.largeTitle)
            .padding()
            
        
    }
    
    
  


    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
